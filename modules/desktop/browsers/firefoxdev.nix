# modules/browser/firefoxdev.nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.browsers.firefoxdev;
in {
  options.modules.desktop.browsers.firefoxdev = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      firefox-devedition
    ];
  };
}
