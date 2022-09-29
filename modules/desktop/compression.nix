{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.compression;
in {
  options.modules.desktop.compression = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      lzop
      p7zip
      unrar
      zip
    ];
  };
}
