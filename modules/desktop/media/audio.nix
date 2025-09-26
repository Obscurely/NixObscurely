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
      clementine
      sox # sample rate converter and spectrograms generator
      easytag # view and edit tags for various audio files
      (makeDesktopItem {
        name = "easytag";
        desktopName = "EasyTAG";
        genericName = "Open EasyTAG in home dir.";
        icon = "easytag";
        exec = "${easytag}/bin/easytag /";
        categories = ["AudioVideo"];
      })
    ];
  };
}
