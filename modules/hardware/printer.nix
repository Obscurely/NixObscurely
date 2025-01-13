{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.printer;
  # TODO: reset back to latest version when fixed
  oldNixpkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/d6f6521030bc948498d5d69bdbe9b48e5d049955.tar.gz";
  }) {};
in {
  options.modules.hardware.printer = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [ oldNixpkgs.epson-escpr ];
  };
}
