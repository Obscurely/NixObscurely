{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.bspwm;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.bspwm = {
    enable = mkBoolOpt false;
    host = mkOpt (with types; nullOr str) null;
  };

  config = mkIf cfg.enable {
    modules.theme.onReload.bspwm = ''
      ${pkgs.bspwm}/bin/bspc wm -r
      source $XDG_CONFIG_HOME/bspwm/bspwmrc
    '';

    environment.systemPackages = with pkgs; [
      lightdm
      libnotify
      (polybar.override {
        pulseSupport = true;
        nlSupport = true;
      })
      feh # image viewer
      betterlockscreen # lockscreen
      xclip
      xdotool
      xorg.xwininfo
      xorg.xinit
      xorg.libXcomposite
      xorg.libXinerama
      xorg.libxcb
      xorg.xkill
      picom # compositor
      flameshot # cool utility for taking screen shots
    ];

    user.packages = with pkgs; [
      (writeScriptBin "rofi" ''
        #!${stdenv.shell}
        exec ${pkgs.rofi}/bin/rofi -terminal xterm -m -1 "$@"
      '')
    ];

    services = {
      displayManager = {
	defaultSession = "none+bspwm";
      };
      xserver = {
        enable = true;
        displayManager = {
          lightdm.enable = true;
          lightdm.greeters.mini.enable = true;
          lightdm.greeters.mini.user = config.user.name;
        };
        windowManager.bspwm.enable = true;
      };
      tumbler.enable = true; # get thumbnails in ristretto
    };

    # this may be needed in some cases
    programs.dconf.enable = true;

    # link recursively so other modules can link files in their folders
    home.configFile = {
      "sxhkd".source = "${configDir}/sxhkd";
      "bspwm" = {
        source = "${configDir}/bspwm/${cfg.host}";
        recursive = true;
      };
      "picom".source = "${configDir}/picom";
      "flameshot".source = "${configDir}/flameshot";
    };
  };
}
