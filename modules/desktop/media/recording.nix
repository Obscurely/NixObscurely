# modules/desktop/media/recording.nix
{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.media.recording;
  configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.media.recording = {
    enable = mkBoolOpt false;
    audio.enable = mkBoolOpt true;
    video.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs;
    # for recording and remastering audio
      (
        if cfg.audio.enable
        then [unstable.audacity unstable.ardour]
        else []
      )
      ++
      # for longer term streaming/recording the screen
      (
        if cfg.video.enable
        then [unstable.obs-studio unstable.handbrake] 
        else []
      );
    home.configFile = with config.modules;
      mkMerge [
        {
          # Template to mix the audio from my audio interface
          "ardour7/templates/Main-Template/Main-Template.template".source = "${configDir}/ardour7/Main-Template.template";
        }
      ];
  };
}
