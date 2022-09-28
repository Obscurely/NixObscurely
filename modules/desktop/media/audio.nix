{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.audio;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.media.audio = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      sonixd # frontend for subsonic compatible servers
      clementine
    ];
  };
}
