# modules/dev/aws.nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  devCfg = config.modules.dev;
  cfg = devCfg.aws;
in {
  options.modules.dev.aws = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        awscli2 # cli for aws
        eksctl # manage eks clusters
      ];
    })
  ];
}
