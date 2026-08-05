#!/usr/bin/env python3
"""Glacial tint for the volantes XCursor theme.

Usage:
  recolor-cursor.py <src-theme-dir> <out-theme-dir>   # tint a copy
  recolor-cursor.py --inspect <cursor-file>           # print chunk dims + bright-pixel sample

volantes ships binary XCursor files (white body + dark outline). We recolor by multiplying the
R/G/B channels toward an icy white (#ffffff -> ~#CCDEF2): the dark outline stays dark (0*k=0), the
white body cools to a light glacial blue, and alpha is untouched — so it stays high-contrast/visible
but integrated with the palette. XCursor stores PREMULTIPLIED ARGB, and a per-channel multiply commutes
with premultiplication, so we scale the stored bytes directly. No dimensions change -> rewrite in place.
"""
import os
import shutil
import struct
import sys

MAGIC = b"Xcur"
IMAGE_TYPE = 0xFFFD0002

# multipliers toward icy-white: #ffffff -> (204,222,242) = #CCDEF2 (light glacial blue)
R_MUL, G_MUL, B_MUL = 0.80, 0.87, 0.95
_RT = bytes(min(255, int(i * R_MUL)) for i in range(256))
_GT = bytes(min(255, int(i * G_MUL)) for i in range(256))
_BT = bytes(min(255, int(i * B_MUL)) for i in range(256))


def _image_chunks(buf):
    """Yield (pixel_offset, width, height) for every image chunk."""
    if buf[:4] != MAGIC:
        return
    _hdr, _ver, ntoc = struct.unpack_from("<III", buf, 4)
    for i in range(ntoc):
        typ, _sub, pos = struct.unpack_from("<III", buf, 16 + i * 12)
        if typ == IMAGE_TYPE:
            chdr, _ct, _cs, _cv, w, h = struct.unpack_from("<IIIIII", buf, pos)
            yield pos + chdr, w, h


def tint_file(path):
    with open(path, "rb") as fh:
        buf = bytearray(fh.read())
    if buf[:4] != MAGIC:
        return False  # not an XCursor (index.theme etc.)
    for px, w, h in _image_chunks(buf):
        end = px + w * h * 4
        for p in range(px, end, 4):  # bytes per pixel: [B, G, R, A]
            buf[p] = _BT[buf[p]]
            buf[p + 1] = _GT[buf[p + 1]]
            buf[p + 2] = _RT[buf[p + 2]]
    with open(path, "wb") as fh:
        fh.write(buf)
    return True


def tint_dir(src, out):
    if os.path.lexists(out):
        for root, _d, _f in os.walk(out):
            try:
                os.chmod(root, 0o755)
            except OSError:
                pass
        shutil.rmtree(out, ignore_errors=True)
    shutil.copytree(src, out, symlinks=True)  # preserve the alias symlinks
    n = 0
    for root, _dirs, files in os.walk(out):
        for name in files:
            p = os.path.join(root, name)
            if os.path.islink(p):
                continue
            try:
                os.chmod(p, 0o644)
            except OSError:
                pass
            try:
                if tint_file(p):
                    n += 1
            except Exception as exc:  # noqa: BLE001
                print(f"skip {p}: {exc}")
    print(f"tinted {n} cursor files -> {out}")


def inspect(path):
    with open(path, "rb") as fh:
        buf = fh.read()
    print(f"magic={buf[:4]!r}")
    for px, w, h in _image_chunks(bytearray(buf)):
        bright = [
            (buf[p + 2], buf[p + 1], buf[p], buf[p + 3])  # (R,G,B,A)
            for p in range(px, px + w * h * 4, 4)
            if buf[p + 3] > 200 and min(buf[p], buf[p + 1], buf[p + 2]) > 170
        ]
        print(f"  chunk {w}x{h}: {len(bright)} bright-opaque px; sample(RGBA)={bright[:3]}")


if __name__ == "__main__":
    if sys.argv[1] == "--inspect":
        inspect(sys.argv[2])
    else:
        tint_dir(sys.argv[1], sys.argv[2])
