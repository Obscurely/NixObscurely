{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.wine;
in {
  options.modules.desktop.gaming.wine = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      wineWowPackages.stagingFull # wine its self
      giflib # gif lib
      openal # openal lib
      haveged # entropy daemon
      v4l-utils
      mpg123
      ocl-icd
      libxslt
      libdbusmenu
      openldap
      winetricks

      dxvk
      mangohud
      gnome.zenity
      auto-cpufreq
      vkBasalt
      goverlay
      earlyoom
      ananicy
      vaapiVdpau
      libgpg-error
      libgcrypt
      ncurses
      libva
      vulkan-tools
      vulkan-loader
      khronos-ocl-icd-loader
      libjpeg
    ];
  };
}
