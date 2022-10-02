# modules/desktop/media/recording.nix

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.recording;
in {
  options.modules.desktop.media.recording = {
    enable = mkBoolOpt false;
    audio.enable = mkBoolOpt true;
    video.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    services.pipewire.jack.enable = true;

    user.packages = with pkgs;
      # for recording and remastering audio
      (if cfg.audio.enable then [ unstable.audacity-gtk3 ] else []) ++
      # for longer term streaming/recording the screen
      (if cfg.video.enable then [ unstable.obs-studio unstable.handbrake ] else []);
  };
}
