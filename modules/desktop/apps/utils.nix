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
      # One-click BleachBit as root on Wayland: grant root X access (Xwayland) then
      # escalate via pkexec (keeps DISPLAY/XAUTHORITY) — same pattern as gparted's
      # launcher; relies on the setuid pkexec wrapper below. User-mode `bleachbit`
      # covers ~; root is for system paths (/var/log, journald, /tmp).
      (writeShellScriptBin "bleachbit-root" ''
        ${xorg.xhost}/bin/xhost +SI:localuser:root
        /run/wrappers/bin/pkexec ${bleachbit}/bin/bleachbit "$@"
        ${xorg.xhost}/bin/xhost -SI:localuser:root
      '')
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

    # GParted (and any polkit pkexec GUI) needs a SETUID pkexec to escalate. This
    # nixpkgs' polkit module gates its own setuid-pkexec wrapper behind
    # `security.polkit.enablePkexecWrapper` (mkEnableOption, default FALSE) — so
    # /run/wrappers/bin/pkexec is absent → "pkexec must be setuid root". Just flip that
    # option on. (Defining our own `security.wrappers.pkexec` does NOT work: it merges
    # with polkit's block, whose `enable = cfg.enablePkexecWrapper` wins and keeps it
    # disabled.) pkexec preserves DISPLAY/XAUTHORITY, so gparted then opens as root on
    # Xwayland (its launcher xhost-grants root itself); `bleachbit-root` calls the same
    # /run/wrappers/bin/pkexec.
    security.polkit.enablePkexecWrapper = true;

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
