# modules/dev/utils.nix
#
# Basic linux utilities for my needs
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.utils;
  inherit (config.dotfiles) configDir;
in {
  options.modules.desktop.apps.utils = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      bleachbit # clean up computer utility
      gnome-calculator # calculator
      gparted # partition manager
      pavucontrol # audio control utility (universal)
      qbittorrent # torrent downloader utility
      ristretto # photo viewer
      xarchiver # archive manager (GTK, Thunar-integrated)
      xfce.thunar-archive-plugin # right-click extract/create in Thunar
	  moonlight-qt # sunshine client


      # libs
      xfce4-exo # this is for xfce shortcuts like open terminal
    ];

    # Get in dotfiles for utils
    home.configFile = with config.modules;
      mkMerge [
        {
          # xfce4 settings
          "xfce4".source = "${configDir}/xfce4";
        }
        {
          # Bleachbit settings
          "bleachbit/bleachbit.ini".source = "${configDir}/bleachbit/bleachbit.ini";
        }
      ];
  };
}
