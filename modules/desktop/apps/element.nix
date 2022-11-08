# modules/dev/element.nix --- https://element.io
#
# The chat app I need, not by choice

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.element;
in {
  options.modules.desktop.apps.element= {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      element-desktop
    ];
  };
}
