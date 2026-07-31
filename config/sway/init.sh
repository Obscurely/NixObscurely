#!/usr/bin/env sh
# ~/.config/sway/init.sh --- exec_always hook.
# Runs on every sway start/reload. Safe no-op by default; Any kind of custom setup goes here

# GTK4/libadwaita apps (and GTK apps via the dconf backend) read theme/icon/
# cursor/font from gsettings, NOT gtk-3.0/settings.ini — so on a GNOME-less
# Wayland session they fall back to Adwaita/no icons. Push the theme here to
# match. (settings.ini still covers pure GTK2/3 apps.)
gsettings set org.gnome.desktop.interface gtk-theme 'Fluent-Dark' 2>/dev/null
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark' 2>/dev/null
gsettings set org.gnome.desktop.interface cursor-theme 'volantes_cursors' 2>/dev/null
gsettings set org.gnome.desktop.interface cursor-size 32 2>/dev/null
gsettings set org.gnome.desktop.interface font-name 'Fira Code 15' 2>/dev/null
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' 2>/dev/null

exit 0
