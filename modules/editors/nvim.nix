# The actual neovim configuration lives in it's own repo and gets automatically installed.
# Updates to it happen outside of NixOS
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.editors.nvim;
in {
  options.modules.editors.nvim = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      editorconfig-core-c
      unstable.neovim
      tree-sitter
    ];
  };
}
