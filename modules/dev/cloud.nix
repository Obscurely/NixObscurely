# modules/dev/cloud.nix
# for cloud agnostic tools
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
  cfg = devCfg.cloud;
in {
  options.modules.dev.cloud = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        terraform # IAC
        terraformer # Infrastructure to code
        ansible # Configure/deploy to infrastructure
      ];
    })
  ];
}
