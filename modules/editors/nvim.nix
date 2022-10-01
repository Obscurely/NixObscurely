# When I'm stuck in the terminal or don't have access to Emacs, (neo)vim is my
# go-to. I am a vimmer at heart, after all.

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
  };
}
