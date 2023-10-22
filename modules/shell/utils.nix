# modules/shell/utils.nix
#
# Handy cli tools I use
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.utils;
in {
  options.modules.shell.utils = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      ncdu
      speedtest-cli # internet speed test in shell
      traceroute # trace ip address to initial ip
      neofetch
      aria # fast cli downloader
      mat2 # utility for removing metadata from files
      netdiscover # discovering devices in local network
      ffmpeg # convert media files
      gifsicle # optimize gifs
      optipng # optimize png
      pngquant # optimize png
      jpegoptim # optimize jpeg
      ghostscript # optimize pdf
      bc # for optimizing photos
      libheif # to view .heic files
      openssl # cryptographic library
      protonup # for managing proton ge
      fontconfig # a dependency for some stuff
      psmisc # a set of small utils like killall, fuser, pstree
      onefetch # information about repo in neofetch style
      wally-cli # tool to flash the firmware on my zsa moonlander keyboard
      awscli2 # cli for aws
    ];

    programs.adb.enable = true;
  };
}
