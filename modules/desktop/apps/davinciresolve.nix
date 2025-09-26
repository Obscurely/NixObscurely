{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.davinciresolve;
in {
  options.modules.desktop.apps.davinciresolve = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      davinci-resolve-studio
    ];
  };
}
