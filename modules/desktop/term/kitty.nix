{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.term.kitty;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.term.kitty = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [kitty];

    home.configFile = {
      "kitty" = {
        source = "${configDir}/kitty";
        recursive = true;
      };
    };
  };
}
