# modules/browser/firefox.nix
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.browsers.firefox;
in {
  options.modules.desktop.browsers.firefox = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.firefox.enable = true;

    programs.firefox.preferences = {
      "browser.eme.ui.enabled" = true;
      "media.eme.enabled" = true;
    };
  };
}
