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
      libnotify
      swaybg # setting the wallpaper
      wl-clipboard # wayland clipboard
      rofi-wayland # Rofi for wayland
      wayshot # for taking screenshots
      grim # grabs the screenshots
      slurp # select a region to screenshot
    ];

    qt.enable = true;

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      hyprlock.enable = true;
    };

    programs.waybar.enable = true;

    services = {
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        defaultSession = "hyprland"; 
      };
      tumbler.enable = true; # get thumbnails in ristretto
    };

    # this may be needed in some cases
    programs.dconf.enable = true;

    home.configFile = {
      "hypr" = {
        source = "${configDir}/hypr/${cfg.host}";
        recursive = true;
      };
    };
  };
}
