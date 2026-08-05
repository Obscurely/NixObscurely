{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.media.mpv;
  inherit (config.dotfiles) configDir;
  # Glacial mpv: bundle the packaged scripts INTO mpv (auto-loaded from its own script dir).
  #   uosc      — the themeable UI: control bar, timeline, searchable menu, file browser, playlist
  #   thumbfast — hover thumbnails on the timeline + in the browser (uosc integrates it)
  #   autoload  — opening one file populates the playlist with the rest of that folder
  #   mpris     — mpv registers as an MPRIS player -> the eww media widget shows/controls it
  # Theming + keybinds + the native-picker glue live in config/mpv (deployed below). See
  # docs/superpowers/specs/2026-08-05-mpv-glacial-design.md.
  mpvGlacial = pkgs.mpv.override {
    scripts = with pkgs.mpvScripts; [uosc thumbfast autoload mpris];
  };
in {
  options.modules.desktop.media.mpv = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      mpvGlacial
      mpvc # CLI controller for mpv
      zenity # native GTK file-open dialog for scripts/open-dialog.lua (glacial via the GTK theme)
    ];

    # ~/.config/mpv: mpv.conf, input.conf, script-opts/uosc.conf (glacial theme), scripts/
    # open-dialog.lua (the native picker). recursive so mpv can still write watch_later/ itself.
    home.configFile."mpv" = {
      source = "${configDir}/mpv";
      recursive = true;
    };
  };
}
