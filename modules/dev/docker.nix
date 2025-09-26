# modules/dev/docker.nix
# for docker dev tools
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  devCfg = config.modules.dev;
  cfg = devCfg.docker;
in {
  options.modules.dev.docker = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        dockerfile-language-server # lsp for docker file
        docker-compose-language-service # lsp for dockercompose
        hadolint # dockerfile linter
      ];
    })
  ];
}
