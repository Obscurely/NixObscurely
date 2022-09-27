{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.vm.virtd;
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
      qemu_full
      swtpm
      vde2
      virt-manager
      virt-viewer
      libvirt
    ];

    virtualisation.libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
      qemu.runAsRoot = true;
    };
  };
}
