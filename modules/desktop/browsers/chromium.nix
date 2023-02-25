# modules/browser/chromium.nix --- https://github.com/ungoogled-software/ungoogled-chromium
#
# Google Chromium, sans integration with google
{
  options,
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
      (makeDesktopItem {
        name = "chromium";
        desktopName = "Chromium";
        genericName = "Open a chromium tab";
        icon = "chromium";
        exec = "${brave}/bin/chromium --ignore-certificate-errors";
        categories = ["Network"];
      })
    ];
  };
}
