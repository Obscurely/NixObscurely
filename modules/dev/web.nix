# modules/dev/web.nix --- web lang
{
  config,
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
        vscode-langservers-extracted
        typescript
        typescript-language-server
        marksman # language server for markdown
        html-tidy # diagnostics for web files
        alex # catches incosiderate writting
        markdownlint-cli2 # markdown lint
        go-grip # markdown preview locally
        proselint # basically it checks your writting.
        deno # fromat and other things
        hugo # backend developer's best friend for building frontends
        htmx-lsp # lsp for htmx
        tailwindcss-language-server # lsp for tailwindcss
        prettierd # prettier as a daemon for improved formatting speeds
        emmet-ls # emmet language server

        # Javascript
        eslint
        eslint_d
        vscode-js-debug # debugger
        webpack-cli # bundle js files
      ];
    })
  ];
}
