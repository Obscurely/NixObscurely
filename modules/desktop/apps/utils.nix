# modules/dev/utils.nix
#
# Basic linux utilities for my needs
{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.utils;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.apps.utils = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      bleachbit # clean up computer utility
      gnome.gnome-calculator # calculator
      gparted # partition manager
      lxappearance # appearance customization tool
      notepadqq # notepad++ but for linux
      pavucontrol # audio control utility (universal)
      postman # http requests utility
      qbittorrent # torrent downloader utility
      xfce.ristretto # photo viewer
      zoom-us # video conference app
      libsForQt5.ark # imo best linux archive manager
      xfce.xfce4-settings # setting manager
      xplr # tui file manager

      # My packages
      my.estash

      # libs
      xfce.exo # this is for xfce shortcuts like open terminal
    ];

    # Get in dotfiles for utils
    home.configFile = with config.modules;
      mkMerge [
        {
          # Dconf
          "dconf".source = "${configDir}/dconf";
        }
        {
          # Notepadqq
          "Notepadqq/Notepadqq.ini".source = "${configDir}/Notepadqq/Notepadqq.ini";
        }
        {
          # xfce4 settings
          "xfce4".source = "${configDir}/xfce4";
        }
      ];
  };
}
