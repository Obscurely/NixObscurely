# modules/hardware/wifi.nix --- support for wifi

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.wifi;
in {
  options.modules.hardware.wifi = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    networking.wireless.iwd = {
      enable = true;
      settings = {
        Settings = {
          AutoConnect = true;
        };
      };
    };

    networking.networkmanager = {
      wifi.backend = "iwd";
      dhcp = "dhcpcd";
    };

    user.packages = [ pkgs.iwgtk ];
  };
}
