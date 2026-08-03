{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.media.audio;
in {
  options.modules.desktop.media.audio = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      sonixd # frontend for subsonic compatible servers
      lollypop # music player (GTK4/libadwaita)
      sox # sample rate converter and spectrograms generator
    ];
  };
}
