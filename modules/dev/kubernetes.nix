# modules/dev/kubernetes.nix --- kubernetes lang
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
  cfg = devCfg.kubernetes;
in {
  options.modules.dev.kubernetes = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        kubectl # manage kubernetes clusters
      ];
    })
  ];
}
