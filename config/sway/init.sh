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

# Lift the kernel's `video=HDMI-A-2:d` DRM force now that sway owns KMS (past the greeter),
# so the 1080p (HDMI-A-2) hotplugs normally and appears in the quick-settings panel as a
# toggleable (still-disabled) output. Boot/greeter stay protected by the force. Needs root
# (writes a DRM sysfs node) → scoped passwordless-sudo rule + helper live in hosts/main.
# `-n` never prompts; harmless no-op on hosts/sessions without the rule.
sudo -n /run/current-system/sw/bin/clear-hdmi-force 2>/dev/null || true

exit 0
