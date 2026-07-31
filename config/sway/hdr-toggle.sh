#!/usr/bin/env sh
# Toggle HDR on the QD-OLED (DP-1). Vulkan renderer must be active
# (modules.desktop.sway.hdr.enable = true, which exports WLR_RENDERER=vulkan).
# 10-bit output is kept on permanently (render_bit_depth 10 in the sway config);
# this only flips the HDR signal on/off. State file drives the notification.
out=DP-1
state="${XDG_RUNTIME_DIR:-/tmp}/sway-hdr-$out"

if [ -f "$state" ]; then
    swaymsg "output $out hdr off"
    rm -f "$state"
    notify-send -t 2000 "HDR off" "$out"
else
    swaymsg "output $out hdr on"
    : > "$state"
    notify-send -t 2000 "HDR on" "$out"
fi
