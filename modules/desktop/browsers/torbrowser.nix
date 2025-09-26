# modules/browser/torbrowser.nix
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.browsers.torbrowser;
in {
  options.modules.desktop.browsers.torbrowser = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      tor-browser-bundle-bin
    ];
  };
}
