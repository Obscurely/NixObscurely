# modules/dev/nix.nix

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.nix;
in {
  options.modules.dev.nix = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        nil # nix language server, for obvious reasons sitting here.
        alejandra # nix code formatter
        statix # lints and suggestions for nix-code
        deadnix # find and remove unused code in nix
      ];
    })
  ];
}
