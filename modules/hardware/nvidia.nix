{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.nvidia;
in {
  options.modules.hardware.nvidia = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        # Vulkan
        vulkan-loader
        vulkan-headers
        vulkan-validation-layers
        vulkan-volk

        # VAAPI
        libva
        nvidia-vaapi-driver
        libva-vdpau-driver

        # Vdpau
        vaapiVdpau
        libvdpau

        # OCL
        ocl-icd

        # Multimedia frameworks support
        gst_all_1.gst-vaapi
      ];
    };

    services.xserver.videoDrivers = ["nvidia"];
    hardware.nvidia.open = true;
    hardware.nvidia.modesetting.enable = true;
    boot.kernelParams = ["nvidia-drm.modeset=1"];
    environment.variables = {
      NVD_BACKEND = "direct";
    };

    environment.systemPackages = with pkgs; [
      # Respect XDG conventions, damn it!
      (writeScriptBin "nvidia-settings" ''
        #!${stdenv.shell}
        mkdir -p "$XDG_CONFIG_HOME/nvidia"
        exec ${config.boot.kernelPackages.nvidia_x11.settings}/bin/nvidia-settings --config="$XDG_CONFIG_HOME/nvidia/settings"
      '')

      vdpauinfo
      pciutils

      # Codecs
      gst_all_1.gstreamer
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-base
    ];

    # Used in something like docker
    hardware.nvidia-container-toolkit.enable = true;
  };
}
