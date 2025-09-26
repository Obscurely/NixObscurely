{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.gaming.wine;
  inherit (config.dotfiles) configDir;
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
      zenity
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
      protonup # for managing proton ge
    ];

    # Get in dotfiles
    home.configFile = with config.modules;
      mkMerge [
        {
          # VkBasalt settings
          "goverlay/vkBasalt.conf".source = "${configDir}/goverlay/vkBasalt.conf";
        }
      ];
  };
}
