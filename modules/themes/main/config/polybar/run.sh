#!/usr/bin/env bash

## Copyright (C) 2020-2022 Aditya Shakya <adi1090x@gmail.com>
## Everyone is permitted to copy and distribute copies of this file under GNU-GPL3

## Files and Directories
DIR="$DOTFILES/modules/themes/main/config/polybar"

## Launch Polybar with selected style
STYLE="default"

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch the bar
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
	MONITOR=$m polybar -q main -c "$DIR/$STYLE/config.ini" &
  done
else
  polybar -q main -c "$DIR/$STYLE/config.ini" &
fi
