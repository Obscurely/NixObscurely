#!/usr/bin/env bash

## Author  : Aditya Shakya
## Mail    : adi1090x@gmail.com
## Github  : @adi1090x
## Twitter : @adi1090x

dir="$HOME/.config/rofi/applets/android"
rofi_command="rofi -theme $dir/six.rasi"

# Links
terminal=""
files=""
editor=""
browser=""
music=""
settings=""

# Error msg
msg() {
	rofi -theme "$dir/message.rasi" -e "$1"
}

# Variable passed to rofi
options="$terminal\n$files\n$editor\n$browser\n$music\n$settings"

chosen="$(echo -e "$options" | $rofi_command -p "Most Used" -dmenu -selected-row 0)"
case $chosen in
    $terminal)
		kitty &
        ;;
    $files)
		thunar &
        ;;
    $editor)
		~/.config/bspwm/nvim.sh & 
        ;;
    $browser)
		chromium --ignore-certificate-errors &
        ;;
    $music)
		sonixd
        ;;
    $settings)
		bitwarden-desktop
        ;;
esac

