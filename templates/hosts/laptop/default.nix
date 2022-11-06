{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    desktop = {
      bspwm = {
          enable = true;
          host = "laptop";
      };
      compression.enable = true;
      apps = {
        bitwarden.enable = true;
        discord.enable = true;
        rofi.enable = true;
        utils.enable = true;
      };
      browsers = {
        default = "firefox";
        chromium.enable = true;
        firefox.enable = true;
        qutebrowser.enable = true;
      };
      gaming = {
        legendary.enable = true;
        lutris.enable = true;
        steam.enable = true;
        wine.enable = true;
      };
      media = {
        audio.enable = true;
        documents.enable = true;
        graphics.enable = true;
        mpv.enable = true;
        recording.enable = true;
      };
      term = {
        default = "xterm-kitty";
        kitty.enable = true;
      };
      vm = {
        virtd.enable = true;
      };
    };
    dev = {
      arduino.enable = true;
      cc.enable = true;
      dotnet.enable = true;
      go.enable = true;
      java.enable = true;
      lua.enable = true;
      node.enable = true;
      python.enable = true;
      rust.enable = true;
      shell.enable = true;
      web.enable = true;
      yaml.enable = true;
    };
    editors = {
      default = "nvim";
      nvim.enable = true;
    };
    hardware = {
      audio.enable = true;
      fs = {
        enable = true;
        ssd.enable = true;
      };
      nvidia.enable = true;
      razer.enable = true;
      sensors.enable = true;
      wifi.enable = true;
      intel.enable = true;
    };
    shell = {
      direnv.enable = true;
      git.enable    = true;
      gnupg.enable  = true;
      utils.enable = true;
      zsh.enable    = true;
    };
    theme.active = "main";
  };

  networking.networkmanager.enable = true;
}
