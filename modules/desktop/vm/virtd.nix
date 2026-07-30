{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.vm.virtd;
in {
  options.modules.desktop.vm.virtd = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      ebtables
      nftables
      bridge-utils
      dnsmasq
      libguestfs
      virtiofsd # file system sharing
      vhost-device-sound # virtio sound
      virtio-win # windows drivers
      netcat
      stable.qemu_full
      swtpm
      vde2
      virt-manager
      virt-viewer
      libvirt
      quickemu # fast way to create optimzed vms
      stable.quickgui # gui for quickemu
      OVMFFull
    ];

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        runAsRoot = true;
      };
    };

    systemd.services.libvirtd.environment = {
      # Tell libglvnd where to find the NVIDIA driver JSON
      __EGL_VENDOR_LIBRARY_FILENAMES = "/run/opengl-driver/share/glvnd/egl_vendor.d/10_nvidia.json";

      # Force the library path so QEMU finds the proprietary libs
      LD_LIBRARY_PATH = "/run/opengl-driver/lib";
    };
  };
}
