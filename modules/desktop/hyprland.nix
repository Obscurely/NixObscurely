{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.hyprland;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.hyprland = {
    enable = mkBoolOpt false;
    host = mkOpt (with types; nullOr str) null;
  };

  config = mkIf cfg.enable {
    modules.theme.onReload.hyprland = ''
      ${pkgs.hyprland}/bin/hyprctl exit && ${pkgs.hyprland}/bin/Hyprland
      source $XDG_CONFIG_HOME/hypr/hyprland.conf
    '';

    environment.systemPackages = with pkgs; [
      dunst
      qt6.qtwayland
    ];

    services = {
      programs.hyprland = {
        enable = true;
        xwayland.enable = true;
      };
      services.xserver.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
      };
      # xserver = {
      #   enable = true;
      #   displayManager = {
      #     defaultSession = "none+bspwm";
      #     lightdm.enable = true;
      #     lightdm.greeters.mini.enable = true;
      #   };
      #   windowManager.bspwm.enable = true;
      # };
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
    };
  };
}
