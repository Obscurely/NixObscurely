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
    ];

    services = {
      # picom = {
      #   enable = true;
      #   #experimentalBackends = true;
      #   backend = "glx";
      # };
      xserver = {
        enable = true;
        displayManager = {
          defaultSession = "none+bspwm";
          lightdm.enable = true;
          lightdm.greeters.mini.enable = true;
        };
        windowManager.bspwm.enable = true;
      };
      tumbler.enable = true; # get thumbnails in ristretto
    };

    # this may be needed in some rare cases
    programs.dconf.enable = true;

    # link recursively so other modules can link files in their folders
    home.configFile = {
      "sxhkd".source = "${configDir}/sxhkd";
      "bspwm" = {
        source = "${configDir}/bspwm/${cfg.host}";
        recursive = true;
      };
      "picom".source = "${configDir}/picom";
    };
  };
}
