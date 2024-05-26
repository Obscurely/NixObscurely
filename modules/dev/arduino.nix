# modules/dev/arudino.nix --- arduino lang
#
# For when really needed
{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  devCfg = config.modules.dev;
  cfg = devCfg.arduino;
in {
  options.modules.dev.arduino = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        arduino-cli
        arduino-language-server
      ];
    })
  ];
}
