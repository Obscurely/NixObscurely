#!/bin/bash
is_waybar_ServerExist=`ps -ef|grep -m 1 waybar|grep -v "grep"|wc -l`
if [ "$is_waybar_ServerExist" = "0" ]; then
	echo "waybar_server not found" > /dev/null 2>&1
#	exit;
elif [ "$is_waybar_ServerExist" = "1" ]; then
  killall waybar
fi

SDIR="$HOME/.config/waybar"

waybar -c "$SDIR"/mocha.jsonc -s "$SDIR"/mocha.css &
