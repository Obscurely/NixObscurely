# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/9d3d0306-a30b-49ef-a2a5-a1cd57d6a628";
      fsType = "f2fs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/7DAA-D9A8";
      fsType = "vfat";
    };

  fileSystems."/home" =
    { device = "/dev/disk/by-uuid/9e602af1-a48b-4682-9e71-2c7da91f5e86";
      fsType = "f2fs";
    };

  fileSystems."/data" =
    { device = "/dev/disk/by-uuid/8e8088eb-c770-48bd-b593-f57fb0a93e6e";
      fsType = "f2fs";
    };

  fileSystems."/extra" =
    { device = "/dev/disk/by-uuid/e34247f9-df30-47c9-9846-5219b6918f35";
      fsType = "xfs";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/c552ad1f-9b63-4853-ac4c-77e1f8a13e05"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp8s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
