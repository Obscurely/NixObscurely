# modules/dev/zoom.nix
# For video conferencing
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.zoom;
in {
  options.modules.desktop.apps.zoom = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      zoom-us # video conference app
    ];
  };
}
