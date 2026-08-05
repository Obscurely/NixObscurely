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
  # gparted as root on Wayland. pkexec sanitises the env (drops DISPLAY), so xhost-grant root
  # access to Xwayland + re-inject DISPLAY via env; the real (env-wrapped) gparted then runs as
  # root — its inner launcher sees id=0, skips its own xhost/pkexec, and runs gpartedbin directly
  # with our DISPLAY. Referenced by hiPrio (PATH shadow) + the .desktop override (absolute Exec).
  gpartedRoot = pkgs.writeShellScriptBin "gparted" ''
    ${pkgs.xorg.xhost}/bin/xhost +SI:localuser:root
    /run/wrappers/bin/pkexec ${pkgs.coreutils}/bin/env DISPLAY="$DISPLAY" ${pkgs.gparted}/bin/gparted "$@"
    ${pkgs.xorg.xhost}/bin/xhost -SI:localuser:root
  '';
in {
  options.modules.desktop.apps.utils = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      bleachbit # clean up computer utility
      # One-click BleachBit as root on Wayland. pkexec SANITISES the environment — DISPLAY is
      # NOT preserved — so the root GUI would die with "cannot open display:". Fix: grant root
      # X access (xhost, Xwayland) AND re-inject DISPLAY across the pkexec boundary via `env`.
      # XAUTHORITY isn't needed (xhost SI:localuser:root authorises root by uid). User-mode
      # `bleachbit` covers ~; root is for system paths (/var/log, journald, /tmp).
      (writeShellScriptBin "bleachbit-root" ''
        ${xorg.xhost}/bin/xhost +SI:localuser:root
        /run/wrappers/bin/pkexec ${coreutils}/bin/env DISPLAY="$DISPLAY" ${bleachbit}/bin/bleachbit "$@"
        ${xorg.xhost}/bin/xhost -SI:localuser:root
      '')
      gnome-calculator # calculator
      gparted # partition manager
      # Shadow `gparted` (hiPrio) with a wrapper that grants root X access + re-injects DISPLAY
      # across pkexec (which strips it) so the root GUI opens on Xwayland; see gpartedRoot in
      # `let`. gparted's .desktop hardcodes an ABSOLUTE Exec (bypassing the PATH shadow), so it's
      # ALSO overridden to this wrapper via home.dataFile below — fixing both terminal + app-menu.
      (hiPrio gpartedRoot)
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
    # disabled.) NOTE: pkexec does NOT preserve DISPLAY — it sanitises the environment — so the
    # gparted/bleachbit-root wrappers above xhost-grant root access to Xwayland AND re-inject
    # DISPLAY via `env` across the pkexec boundary (without it the root GUI can't open a display).
    security.polkit.enablePkexecWrapper = true;

    # gparted's .desktop hardcodes an absolute Exec to the store binary, bypassing the PATH
    # shadow — override it (XDG_DATA_HOME wins by desktop-id) to launch the root wrapper. Only
    # the Exec line is rewritten; all upstream fields/translations are kept.
    home.dataFile."applications/gparted.desktop".source = pkgs.runCommand "gparted-root-desktop" {} ''
      ${pkgs.gnused}/bin/sed 's|^Exec=.*|Exec=${gpartedRoot}/bin/gparted %f|' \
        ${pkgs.gparted}/share/applications/gparted.desktop > $out
    '';

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
