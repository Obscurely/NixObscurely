#!/usr/bin/env python3
"""Build the Mont-Blanc-Dark ICON theme from Papirus-Dark by recoloring.

Usage: recolor-icons.py <src Papirus-Dark dir> <out theme dir>

Strategy (see docs/superpowers/specs glacial-icon-theme design):
  - Papirus-Dark's themeable icons hardcode a compact shared palette (line-art grey +
    blue/orange/red/green accents) plus the folder blues. We map those exact hexes to the
    glacial palette (docs/glacial-design-language.md). Because the map targets ONLY Papirus's
    own palette hexes, brand app icons / emoji (which use other colors) are left untouched.
  - `apps/` is excluded entirely (brand recognizability) -> inherited from stock Papirus-Dark.
  - Symlinks are dereferenced (symlinks=False) so escaping links into stock Papirus resolve to
    real files that then get recolored; internal aliases become real recolored copies.
  - index.theme is renamed and set to inherit Papirus-Dark (fallback for apps + anything missed).
"""
import os
import re
import shutil
import sys

# glacial palette (docs/glacial-design-language.md + GTK theme semantic colors)
#   text #CBD8EA · text2 #90A4BC · occupied #5E8DB8 · accent #8CC6F2 · accent-br #A6CCEC
#   inactive #4C5D72 · selection steel #34506B · error #E58A8A · warn #E7B872 · success #8FC7B4
COLORMAP = {
    # --- neutral line-art / greys -> icy foreground ladder ---
    "#dfdfdf": "#CBD8EA",  # the dominant line-art color -> $text
    "#e3e3e3": "#CBD8EA",
    "#d3dae3": "#CBD8EA",
    "#e4e4e4": "#CBD8EA",  # folder paper highlight
    "#ffffff": "#E8F0F8",  # pure white -> very light icy (keep highlights readable)
    "#a9a9a9": "#90A4BC",  # mid grey -> $text2
    "#8e8e8e": "#7C8CA3",
    "#676767": "#4C5D72",  # dark grey -> $inactive
    "#4f4f4f": "#3A4757",
    "#3f3f3f": "#2E3B49",  # near-black line -> dark border
    "#4d4d4d": "#3A4757",
    "#232629": "#1B2530",  # breeze dark bg
    "#eff0f1": "#CBD8EA",  # breeze light text
    # --- primary blue accents -> glacial accent family ---
    "#4285f4": "#8CC6F2",  # the dominant accent blue -> $accent
    "#3b5df4": "#6FA8DC",
    "#1d99f3": "#79C0E8",
    "#57b8ec": "#8CC6F2",
    "#93c0ea": "#A6CCEC",
    "#3daee9": "#8CC6F2",  # breeze highlight
    "#3a539b": "#3E6488",
    "#5c6bc0": "#5E8DB8",  # indigo -> $occupied
    "#81a1c1": "#90A4BC",  # nord blue-grey -> $text2
    "#607d8b": "#7C8CA3",  # blue-grey -> $text2
    # --- folder blues (face #5294e2 / back #4877b1) ---
    "#5294e2": "#5E8DB8",  # folder face -> $occupied
    "#4877b1": "#34506B",  # folder tab/back -> selection steel (darker, for depth)
    # --- reds -> glacial error ---
    "#f44336": "#E58A8A",
    "#e24f51": "#E58A8A",
    "#e25252": "#E58A8A",
    "#eb6637": "#E58A8A",
    "#a30002": "#B85C5C",  # dark red -> muted
    "#f06292": "#E39BB0",  # pink -> muted rose
    # --- oranges / ambers -> glacial warn amber ---
    "#ff9800": "#E7B872",
    "#f27935": "#E7B872",
    "#ee923a": "#E7B872",
    "#f9bd30": "#E7C98A",
    "#fdbc4b": "#E7C98A",
    "#fdd285": "#EBD4A0",
    "#eeca8f": "#EBD4A0",
    "#ae8e6c": "#A79A80",  # tan -> muted
    "#d1bfae": "#C3C9C0",
    # --- greens / teals -> glacial success ---
    "#4caf50": "#8FC7B4",
    "#96e24f": "#A6D4B0",
    "#7fcc74": "#8FC7B4",
    "#75e73c": "#A6D4B0",
    "#4fef42": "#8FC7B4",
    "#87b158": "#8FC7B4",
    "#16a085": "#5EB6A0",
    "#04896a": "#3E8F78",
    # --- purples / cyans -> muted icy ---
    "#7e57c2": "#8C9BD8",
    "#ca71df": "#B79BD8",
    "#45abb7": "#6FB8C4",
    # --- broad tail neutrals/blues (high-frequency leftovers) ---
    "#3a87e5": "#8CC6F2",  # secondary blue -> $accent
    "#3f51b5": "#5E8DB8",  # indigo -> $occupied
    "#444444": "#3A4757",  # dark line-art -> dark icy
    "#323232": "#2E3B49",
    "#eaeaea": "#E8F0F8",  # near-white
    "#fafafa": "#E8F0F8",
    "#f5f5f5": "#DCE6F0",
    "#c2c2c2": "#90A4BC",  # light grey -> $text2
    "#1d344f": "#1B2C3F",  # dark navy (already cool) -> keep cool
    "#3b4253": "#2E3B49",  # dark slate -> border
}

_pat = re.compile("|".join(re.escape(k) for k in COLORMAP), re.IGNORECASE)


def _repl(m):
    return COLORMAP[m.group(0).lower()]


def build(srcdir, outdir):
    """Recursively mirror srcdir -> outdir, skipping apps/. Internal aliases (folder.svg ->
    folder-blue.svg, @2x -> larger size) are recreated as symlinks so they point at the
    recolored siblings; symlinks escaping into the stock Papirus tree are DEREFERENCED to real
    files so they get recolored too. (shutil.copytree can't do this: its dangling-symlink test
    resolves the raw link target against the CWD, so it skips every relative symlink.)"""
    os.makedirs(outdir, exist_ok=True)
    for name in sorted(os.listdir(srcdir)):
        if name == "apps":
            continue
        sp = os.path.join(srcdir, name)
        dp = os.path.join(outdir, name)
        if os.path.islink(sp):
            raw = os.readlink(sp)
            real = os.path.realpath(sp)
            escaping = os.path.isabs(raw) or "Papirus/" in raw
            if not escaping:
                # internal alias -> keep as a symlink to the recolored sibling
                if not os.path.lexists(dp):
                    os.symlink(raw, dp)
            elif os.path.isdir(real):
                build(real, dp)
            elif os.path.isfile(real):
                shutil.copyfile(real, dp)
            # dangling -> skip
        elif os.path.isdir(sp):
            build(sp, dp)
        elif os.path.isfile(sp):
            shutil.copyfile(sp, dp)


def main():
    src, out = sys.argv[1], sys.argv[2]
    if os.path.lexists(out):
        # a prior tree may have read-only dirs (nix-store modes) -> make writable first
        for root, _dirs, _files in os.walk(out):
            try:
                os.chmod(root, 0o755)
            except OSError:
                pass
        shutil.rmtree(out, ignore_errors=True)
    build(src, out)
    # make the tree writable (source came from the read-only nix store)
    os.chmod(out, 0o755)
    for root, dirs, files in os.walk(out):
        for name in dirs + files:
            p = os.path.join(root, name)
            if os.path.islink(p):
                continue
            try:
                os.chmod(p, 0o644 if os.path.isfile(p) else 0o755)
            except OSError:
                pass
    # recolor every real svg (map only hits Papirus palette hexes -> brand/emoji icons untouched)
    changed = 0
    for root, _dirs, files in os.walk(out):
        for name in files:
            if not name.endswith(".svg"):
                continue
            p = os.path.join(root, name)
            if os.path.islink(p):
                continue
            try:
                with open(p, encoding="utf-8") as fh:
                    s = fh.read()
            except (OSError, UnicodeDecodeError):
                continue
            ns = _pat.sub(_repl, s)
            if ns != s:
                with open(p, "w", encoding="utf-8") as fh:
                    fh.write(ns)
                changed += 1
    # rename + reparent the theme
    idx = os.path.join(out, "index.theme")
    if os.path.exists(idx):
        with open(idx, encoding="utf-8") as fh:
            lines = fh.readlines()
        newlines = []
        for ln in lines:
            if ln.startswith("Name="):
                ln = "Name=Mont-Blanc-Dark\n"
            elif ln.startswith("Inherits="):
                ln = "Inherits=Papirus-Dark,breeze-dark,hicolor\n"
            elif ln.startswith("Comment="):
                ln = "Comment=Glacial recolor of Papirus-Dark (Mont-Blanc-Dark)\n"
            newlines.append(ln)
        with open(idx, "w", encoding="utf-8") as fh:
            fh.writelines(newlines)
    # stale cache would misresolve after recolor/rename
    cache = os.path.join(out, "icon-theme.cache")
    if os.path.lexists(cache):
        try:
            os.remove(cache)
        except OSError:
            pass
    print(f"recolored {changed} svgs -> {out}")


if __name__ == "__main__":
    main()
