{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.compression;
in {
  options.modules.compression= with types; {
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
