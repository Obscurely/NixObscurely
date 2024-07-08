{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.nvopen;
in {
  options.modules.hardware.nvopen = {
    enable = mkBoolOpt false;
  };

  # Make sure the xserver is disabled
  services.xserver.enable = false;

  # Make sure the nouveau module is loaded
  boot.initrd.kernelModules = [ "nouveau" ];

  config = mkIf cfg.enable {
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        nvidia-vaapi-driver 
      ];
    };

    services.xserver.videoDrivers = ["nouveau"];
    boot.kernelParams = ["nouveau.config=NvGspRm=1"];
    environment.variables = {
      NVD_BACKEND = "direct";
    };

    # Blacklist proprietary NVIDIA drivers
    boot.blacklistedKernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
  };
}
