# modules/dev/lua.nix --- https://www.lua.org/

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.lua;
in {
  options.modules.dev.lua = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.enableXDG;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        lua
        luaPackages.moonscript
        sumneko-lua-language-server
        nodePackages.lua-fmt
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
