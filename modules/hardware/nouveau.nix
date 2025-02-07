{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.nouveau;
in {
  options.modules.hardware.nouveau = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        # OpenGL + Vulkan
        mesa
        mesa.drivers
        vulkan-loader
        vulkan-headers
        vulkan-validation-layers
        vulkan-volk

        # VAAPI
        libva
        libva-vdpau-driver

        # VDPAU
        libvdpau
        libvdpau-va-gl

        # OpenCL
        mesa.opencl
        ocl-icd

        # OpenMAX
        mesa.osmesa

        # Multimedia frameworks support
        gst_all_1.gst-vaapi
      ];
      extraPackages32 = with pkgs.driversi686Linux; [
        # Some 32-bit alternatives
        mesa
        mesa.drivers
        libva-vdpau-driver
        libvdpau-va-gl
        mesa.opencl
        mesa.osmesa
      ];
    };

    environment.systemPackages = with pkgs; [
      vdpauinfo

      # Codecs
      gst_all_1.gstreamer
      gst_all_1.gst-libav
      gst_all_1.gst-plugins-base
    ];

    boot = {
      # Make sure the nouveau module is loaded
      initrd.kernelModules = ["nouveau"];
	  # A fix for the nouveau driver
      kernelParams = ["nouveau.config=NvGspRm=1"];
	  # Make sure the proprietary NVIDIA drivers are blacklisted
      blacklistedKernelModules = ["nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm"];
    };

	# Set nouveau as the default video driver
    services.xserver.videoDrivers = ["nouveau"];

	# Configure the environment variables
    environment.variables = {
      NVD_BACKEND = "direct";
    };
  };
}
