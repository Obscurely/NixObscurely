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
      netcat
      stable.qemu_full
      swtpm
      vde2
      virt-manager
      virt-viewer
      libvirt
      quickemu # fast way to create optimzed vms
      stable.quickgui # gui for quickemu
    ];

    virtualisation.libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
        runAsRoot = true;
        ovmf.enable = true;
        ovmf.packages = [pkgs.OVMFFull.fd];
      };
    };
  };
}
