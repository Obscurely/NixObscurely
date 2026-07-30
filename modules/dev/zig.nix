# modules/dev/zig.nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  devCfg = config.modules.dev;
  cfg = devCfg.zig;
in {
  options.modules.dev.zig = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        zig
        zls
        zig-zlint
      ];
    })
  ];
}
