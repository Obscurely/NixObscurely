# modules/shell/utils.nix
#
# Handy cli tools I use
{
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
    # ZSA keyboard udev rules (uaccess) — flash the Moonlander without sudo; needed by keymapp.
    hardware.keyboard.zsa.enable = true;

    user.packages = with pkgs; [
      ncdu
      speedtest-cli # internet speed test in shell
      traceroute # trace ip address to initial ip
      fastfetch
      aria2 # fast cli downloader
      mat2 # utility for removing metadata from files
      netdiscover # discovering devices in local network
      ffmpeg # convert media files
      libheif # to view .heic files
      openssl # cryptographic library
      fontconfig # a dependency for some stuff
      psmisc # a set of small utils like killall, fuser, pstree
      onefetch # information about repo in neofetch style
      wally-cli # legacy ZSA flasher (deprecated — rejects current Oryx firmware; kept as fallback)
      keymapp # current ZSA flasher (GUI) — flashes the new ZSA-VID firmware wally-cli can't
      btop # better htop
      poppler-utils # pdf utils like pdf to text
      tesseract # ocr tool
      lsof # view ports usage
      ipcalc # calculate ip ranges
      claude-code # claude agent
      opencode # runs on top of claude-code and other models
      pass # for authentication
      android-tools # adb tools
    ];
  };
}
