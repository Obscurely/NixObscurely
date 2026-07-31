#!/usr/bin/env sh
# Toggle VRR (adaptive sync / GSYNC) on the QD-OLED (DP-1).
# Kept as a toggle (default off) because VRR on OLED can cause brightness/gamma
# flicker in dark or variable-framerate scenes — flip it on for gaming, off for
# the desktop. To target whatever monitor is focused instead, replace the `out=`
# line with:  out=$(swaymsg -t get_outputs | jq -r '.[]|select(.focused).name')
out=DP-1
state="${XDG_RUNTIME_DIR:-/tmp}/sway-vrr-$out"

if [ -f "$state" ]; then
    swaymsg "output $out adaptive_sync off"
    rm -f "$state"
    notify-send -t 2000 "VRR off" "$out"
else
    swaymsg "output $out adaptive_sync on"
    : > "$state"
    notify-send -t 2000 "VRR on" "$out"
fi
