# modules/browser/chromium.nix --- https://github.com/ungoogled-software/ungoogled-chromium
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.browsers.chromium;
in {
  options.modules.desktop.browsers.chromium = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      ungoogled-chromium
    ];
  };
}
