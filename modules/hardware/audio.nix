{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.audio;
  configDir = config.dotfiles.configDir;
in {
  options.modules.hardware.audio = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
    };

    security.rtkit.enable = true;

    environment.systemPackages = with pkgs; [
      easyeffects
      alsa-plugins
      alsa-utils
      alsa-lib
      alsa-tools
      pulseaudio # for the tools
      playerctl # for media keys
    ];

    # Easyeffects config
    home.configFile = with config.modules;
      mkMerge [
        {
          "easyeffects/rnnoise".source = "${configDir}/easyeffects/rnnoise";
          "easyeffects/Discord and Record.json".source = "${configDir}/easyeffects/Discord and Record.json";
          "easyeffects/Main.json".source = "${configDir}/easyeffects/Main.json";
          #"easyeffects/out.json".source = "${configDir}/easyeffects/output/out.json"; # TODO actually add config in the repo
        }
      ];

    # HACK Prevents ~/.esd_auth files by disabling the esound protocol module
    #      for pulseaudio, which I likely don't need. Is there a better way?
    services.pulseaudio.configFile = let
      inherit (pkgs) runCommand pulseaudio;
      paConfigFile =
        runCommand "disablePulseaudioEsoundModule"
        {buildInputs = [pulseaudio];} ''
          mkdir "$out"
          cp ${pulseaudio}/etc/pulse/default.pa "$out/default.pa"
          sed -i -e 's|load-module module-esound-protocol-unix|# ...|' "$out/default.pa"
        '';
    in
      mkIf config.hardware.pulseaudio.enable
      "${paConfigFile}/default.pa";

    user.extraGroups = ["audio"];
  };
}
