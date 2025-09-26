# modules/dev/jav.nix --- java lang
#
# For when really needed
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  devCfg = config.modules.dev;
  cfg = devCfg.java;
in {
  options.modules.dev.java = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      programs.java.enable = true;
      user.packages = with pkgs; [
        jdk
        java-language-server
      ];
    })
  ];
}
