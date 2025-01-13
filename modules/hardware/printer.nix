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
in {
  options.modules.hardware.printer = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.printing.enable = true;
    services.printing.drivers = with pkgs; [ epson-escpr epson-escpr2 ];
  };
}
