{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.printer;
  oldNixpkgs = import (fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/d6f6521030bc948498d5d69bdbe9b48e5d049955.tar.gz";
  }) {};
in {
  options.modules.hardware.printer = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.printing.enable = true;
    services.printing.drivers = [oldNixpkgs.epson-escpr];
  };
}
