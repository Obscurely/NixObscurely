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
          host = "main";
      };
      compression.enable = true;
      apps = {
        bitwarden.enable = true;
        discord.enable = true;
        element.enable = true;
        rofi.enable = true;
        utils.enable = true;
      };
      browsers = {
        default = "librewolf";
        chromium.enable = true;
        librewolf.enable = true;
        torbrowser.enable = true;
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
	st.enable = true;
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
      wifi.enable = false;
    };
    shell = {
      direnv.enable = true;
      git.enable    = true;
      gnupg.enable  = true;
      utils.enable = true;
      vaultwarden.enable = true;
      zsh.enable    = true;
    };
    theme.active = "main";
  };

  networking.networkmanager.enable = true;

  ## Extra fix for resolution and monitor placement
  environment.etc = {
    "X11/xorg.conf.d/52-resolution-fix.conf".text = ''
      Section "Monitor"
          Identifier "DP-0"
          Option "PreferredMode" "2560x1440"
          Option "Primary" "1"
      EndSection
      Section "Monitor"
          Identifier "DVI-D-0"
          Option "PreferredMode" "1920x1080"
          Option "RightOf" "DP-0"
      EndSection
    '';
  };
}
