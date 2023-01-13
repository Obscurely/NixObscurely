{ config, options, pkgs, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.term.wezterm;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.term.wezterm = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [ wezterm ];

    # home.configFile = {
      # "kitty" = { source = "${configDir}/kitty"; recursive = true; };
    # };
  };
}
