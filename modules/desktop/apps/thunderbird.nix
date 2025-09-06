# modules/dev/thunderbird.nix
{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.apps.thunderbird;
in {
  options.modules.desktop.apps.thunderbird = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      thunderbird
	  protonmail-bridge # for using protonmail with thunderbird
    ];

    services.passSecretService.enable = true;
  };
}
