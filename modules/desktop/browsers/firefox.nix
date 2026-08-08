# modules/browser/firefox.nix
{
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

    # Firefox Developer Edition = a separate Firefox (own profile/bookmarks + distinct
    # app_id "firefox-devedition") used as the ws7 dev/reference browser.
    user.packages = [pkgs.firefox-devedition-bin];

    programs.firefox.preferences = {
      "browser.eme.ui.enabled" = true;
      "media.eme.enabled" = true;
    };
  };
}
