{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.syncthing;
  configDir = config.dotfiles.configDir;
in {
  options.modules.services.syncthing = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      openDefaultPorts = true;
      user = config.user.name;
      configDir = "${config.user.home}/.config/syncthing";
      dataDir = "${config.user.home}/.local/share/syncthing";
    };

    # Syncthing config
    home.configFile = with config.modules;
      mkMerge [
        {
          "syncthing/config.xml".source = "${configDir}/syncthing/config.xml";
        }
      ];
  };
}
