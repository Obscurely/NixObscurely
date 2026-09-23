{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.gaming.prismlauncher;
in {
  options.modules.desktop.gaming.prismlauncher = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      prismlauncher # open-source Minecraft launcher (MultiMC/PolyMC successor)
    ];
  };
}
