# modules/dev/web.nix --- web lang
#
# For when really needed
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
  cfg = devCfg.web;
in {
  options.modules.dev.web = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        nodePackages.vscode-langservers-extracted
        nodePackages_latest.vscode-html-languageserver-bin
        nodePackages.typescript
        nodePackages.typescript-language-server
        marksman # language server for markdown
        html-tidy # diagnostics for web files
        alex # catches incosiderate writting
        mdl # markdown lint
        proselint # basically it checks your writting.
      ];
    })
  ];
}
