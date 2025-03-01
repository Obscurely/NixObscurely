{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.term.alacritty;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.term.alacritty = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [alacritty];

    home.configFile = {
      "alacritty" = {
        source = "${configDir}/alacritty";
        recursive = true;
      };
    };
  };
}
