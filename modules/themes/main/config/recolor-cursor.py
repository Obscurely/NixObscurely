#!/usr/bin/env python3
"""Glacial tint (+ optional downscale) for the volantes XCursor theme.

Usage:
  recolor-cursor.py <src-theme-dir> <out-theme-dir> [scale]   # tint (+ resize if scale given)
  recolor-cursor.py --inspect <cursor-file>                   # print chunk dims + bright-pixel sample

volantes ships binary XCursor files (white body + dark outline). We:
  1. TINT — multiply R/G/B toward icy white (#ffffff -> ~#CCDEF2); the dark outline stays dark
     (0*k=0), the body cools to a light glacial blue, alpha untouched -> still high-contrast.
     XCursor stores PREMULTIPLIED ARGB and a per-channel multiply commutes with premultiplication,
     so we scale the stored bytes directly.
  2. RESIZE (optional) — volantes only ships fixed native sizes (24/32/48/64) and on a fractional
     scale the compositor snaps to a native, so there's no true "in-between" size. Passing a scale
     (e.g. 0.875 = 32->28) bakes a physically smaller image into every cursor (magick does the pixel
     resize, un-premultiplied), rebuilding the XCursor container. With the theme pre-shrunk, base
     size 32 renders ~42px on the 4K@1.5 = a "28 equivalent". See the cursor spec.
"""
import os
import shutil
import struct
import subprocess
import sys

MAGIC = b"Xcur"
IMAGE_TYPE = 0xFFFD0002

# tint toward icy-white: #ffffff -> (204,222,242) = #CCDEF2 (light glacial blue)
R_MUL, G_MUL, B_MUL = 0.80, 0.87, 0.95
_RT = bytes(min(255, int(i * R_MUL)) for i in range(256))
_GT = bytes(min(255, int(i * G_MUL)) for i in range(256))
_BT = bytes(min(255, int(i * B_MUL)) for i in range(256))


def _read_chunks(buf):
    """[[subtype, w, h, xhot, yhot, delay, pixels(bytearray)], ...] for each image chunk."""
    if buf[:4] != MAGIC:
        return None
    _hdr, _ver, ntoc = struct.unpack_from("<III", buf, 4)
    out = []
    for i in range(ntoc):
        typ, _sub, pos = struct.unpack_from("<III", buf, 16 + i * 12)
        if typ != IMAGE_TYPE:
            continue
        chdr, _ct, cs, _cv, w, h, xh, yh, delay = struct.unpack_from("<IIIIIIIII", buf, pos)
        out.append([cs, w, h, xh, yh, delay, bytearray(buf[pos + chdr : pos + chdr + w * h * 4])])
    return out


def _write_xcursor(chunks):
    ntoc = len(chunks)
    head = struct.pack("<4sIII", MAGIC, 16, 0x10000, ntoc)
    pos = 16 + ntoc * 12
    toc, body = bytearray(), bytearray()
    for sub, w, h, xh, yh, delay, px in chunks:
        chunk = struct.pack("<IIIIIIIII", 36, IMAGE_TYPE, sub, 1, w, h, xh, yh, delay) + bytes(px)
        toc += struct.pack("<III", IMAGE_TYPE, sub, pos)
        body += chunk
        pos += len(chunk)
    return head + bytes(toc) + bytes(body)


def _tint_px(px):
    for p in range(0, len(px), 4):  # bytes per pixel: [B, G, R, A]
        px[p] = _BT[px[p]]
        px[p + 1] = _GT[px[p + 1]]
        px[p + 2] = _RT[px[p + 2]]


def _resize_px(px, w, h, nw, nh):
    # premult [B,G,R,A] -> straight RGBA for magick, resize, -> premult [B,G,R,A]
    st = bytearray(len(px))
    for i in range(0, len(px), 4):
        a = px[i + 3]
        if a:
            st[i] = min(255, px[i + 2] * 255 // a)      # R
            st[i + 1] = min(255, px[i + 1] * 255 // a)  # G
            st[i + 2] = min(255, px[i] * 255 // a)      # B
            st[i + 3] = a
    res = subprocess.run(
        ["magick", "-depth", "8", "-size", f"{w}x{h}", "rgba:-",
         "-filter", "Lanczos", "-resize", f"{nw}x{nh}!", "-depth", "8", "rgba:-"],
        input=bytes(st), capture_output=True, check=True,
    ).stdout
    out = bytearray(nw * nh * 4)
    for i in range(0, len(out), 4):
        a = res[i + 3]
        out[i] = res[i + 2] * a // 255      # B
        out[i + 1] = res[i + 1] * a // 255  # G
        out[i + 2] = res[i] * a // 255      # R
        out[i + 3] = a
    return out


def process_file(path, scale):
    with open(path, "rb") as fh:
        buf = fh.read()
    chunks = _read_chunks(buf)
    if not chunks:
        return False  # not an XCursor (index.theme etc.)
    for c in chunks:
        _tint_px(c[6])
    if scale != 1.0:
        for c in chunks:
            _sub, w, h, xh, yh, _delay, px = c
            nw, nh = max(1, round(w * scale)), max(1, round(h * scale))
            c[0] = max(1, round(c[0] * scale))  # nominal size
            c[1], c[2] = nw, nh
            c[3], c[4] = round(xh * scale), round(yh * scale)  # hotspot
            c[6] = _resize_px(px, w, h, nw, nh)
    with open(path, "wb") as fh:
        fh.write(_write_xcursor(chunks))
    return True


def tint_dir(src, out, scale):
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
                if process_file(p, scale):
                    n += 1
            except Exception as exc:  # noqa: BLE001
                print(f"skip {p}: {exc}")
    print(f"processed {n} cursor files (tint, scale={scale}) -> {out}")


def inspect(path):
    with open(path, "rb") as fh:
        buf = fh.read()
    print(f"magic={buf[:4]!r}")
    for sub, w, h, _xh, _yh, _d, px in _read_chunks(bytearray(buf)) or []:
        bright = [
            (px[p + 2], px[p + 1], px[p], px[p + 3])  # (R,G,B,A)
            for p in range(0, len(px), 4)
            if px[p + 3] > 200 and min(px[p], px[p + 1], px[p + 2]) > 150
        ]
        print(f"  chunk {w}x{h} (nominal {sub}): {len(bright)} bright px; sample(RGBA)={bright[:2]}")


if __name__ == "__main__":
    if sys.argv[1] == "--inspect":
        inspect(sys.argv[2])
    else:
        tint_dir(sys.argv[1], sys.argv[2], float(sys.argv[3]) if len(sys.argv) > 3 else 1.0)
