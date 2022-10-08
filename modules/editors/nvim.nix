# Neovim: the second love of my life
# For me all other text editors are trash against my configured neovim.

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.nvim;
    configDir = config.dotfiles.configDir;
in {
  options.modules.editors.nvim = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      editorconfig-core-c
      unstable.neovim
    ];

    # enable wakapi config
    home.configFile = with config.modules; mkMerge [
      {
        "../.wakatime.cfg".source = "${configDir}/wakapi/.wakatime.cfg";
      }
    ];
  };
}
