{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  ## Modules
  modules = {
    desktop = {
      bspwm.enable = true;
      apps = {
        rofi.enable = true;
        bitwarden.enable = true;
        utils.enable = true;
      };
      browsers = {
        default = "firefox";
        chromium.enable = true;
        firefox.enable = true;
        qutebrowser.enable = true;
      };
      gaming = {
        steam.enable = true;
        legendary.enable = true;
        lutris.enable = true;
        wine.enable = true;
      };
      media = {
        daw.enable = true;
        documents.enable = true;
        graphics.enable = true;
        mpv.enable = true;
        recording.enable = true;
        audio.enable = true;
      };
      term = {
        default = "xterm";
        kitty.enable = true;
      };
      vm = {
        virtd.enable = true;
      };
      compression.enable = true;
    };
    dev = {
      cc.enable = true;
      node.enable = true;
      rust.enable = true;
      python.enable = true;
    };
    editors = {
      default = "nvim";
      vim.enable = true;
    };
    shell = {
      direnv.enable = true;
      git.enable    = true;
      gnupg.enable  = true;
      zsh.enable    = true;
      utils.enable = true;
    };
    hardware = {
      audio.enable = true;
      fs = {
        enable = true;
        ssd.enable = true;
      };
    };
    services = {
      ssh.enable = true;
      # docker.enable = true;
      # Needed occasionally to help the parental units with PC problems
      # teamviewer.enable = true;
    };
    theme.active = "main";
  };


  ## Local config
  programs.ssh.startAgent = true;
  services.openssh.startWhenNeeded = true;

  networking.networkmanager.enable = true;
}
