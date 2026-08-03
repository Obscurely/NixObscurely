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
    environment.variables = {
      NVD_BACKEND = "direct";
      LIBVA_DRIVER_NAME = "nvidia";
    };

    environment.systemPackages = with pkgs; [

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
