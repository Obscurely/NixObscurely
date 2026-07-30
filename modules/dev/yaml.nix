# modules/dev/yaml.nix --- yaml lang
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  devCfg = config.modules.dev;
  cfg = devCfg.yaml;
in {
  options.modules.dev.yaml = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        yaml-language-server
        yamlfmt
        yamllint
        actionlint # github actions linter
      ];
    })
  ];
}
