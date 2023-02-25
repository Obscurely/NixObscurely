# modules/dev/dotnet.nix --- dotnet
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
  cfg = devCfg.dotnet;
in {
  options.modules.dev.dotnet = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        dotnet-sdk
        vscode-extensions.ms-dotnettools.csharp
      ];
    })
  ];
}
