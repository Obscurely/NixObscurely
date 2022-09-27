{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.fs;
in {
  options.modules.hardware.fs = {
    enable = mkBoolOpt false;
    amd.enable = mkBoolOpt false;
    intel.enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.zfs.enable (mkMerge [
      {
        user.packages = [ pkgs.microcodeAmd ];
      }
    ]))

    (mkIf cfg.zfs.enable (mkMerge [
      {
        user.packages = [ pkgs.microcodeIntel ];
      }
    ]))
  ]);
}
