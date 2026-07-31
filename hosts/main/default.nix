{...}: {
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    desktop = {
      sway = {
        enable = true;
        host = "main";
      };
      compression.enable = true;
      apps = {
        discord.enable = true;
        slack.enable = true;
        element.enable = false;
        rofi.enable = true;
        utils.enable = true;
      };
      browsers = {
        default = "zen";
        chromium.enable = true;
        torbrowser.enable = true;
        zen.enable = true;
        firefox.enable = true;
      };
      gaming = {
        legendary.enable = false;
        heroic.enable = false;
        lutris.enable = false;
        bottles.enable = false;
        steam.enable = false;
        wine.enable = false;
      };
      media = {
        audio.enable = true;
        documents.enable = true;
        graphics.enable = true;
        mpv.enable = true;
        recording.enable = true;
        tidal.enable = true;
      };
      term = {
        default = "alacritty";
        alacritty.enable = true;
      };
      vm = {
        virtd.enable = true;
      };
    };
    dev = {
      aws.enable = true;
      cloud.enable = true;
      arduino.enable = true;
      cc.enable = true;
      docker.enable = true;
      dotnet.enable = true;
      go.enable = true;
      java.enable = true;
      kubernetes.enable = true;
      lua.enable = true;
      node = {
        enable = true;
        xdg.enable = true;
      };
      python = {
        enable = true;
        xdg.enable = true;
      };
      rust = {
        enable = true;
        xdg.enable = true;
      };
      zig.enable = true;
      shell.enable = true;
      web.enable = true;
      yaml.enable = true;
      nix.enable = true;
      utils.enable = true;
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
      sensors.enable = true;
      printer.enable = true;
      wifi.enable = false;
    };
    services = {
      docker.enable = true;
      syncthing.enable = true;
    };
    shell = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      tmux.enable = true;
      utils.enable = true;
      zsh.enable = true;
      optimize.enable = true;
    };
    theme.active = "main";
  };

  networking.networkmanager.enable = true;
}
