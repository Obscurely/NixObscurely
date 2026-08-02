{
  pkgs,
  config,
  ...
}: let
  # Undo the `video=HDMI-A-2:d` DRM force at session start (called from config/sway/init.sh).
  # The kernel force keeps the 1080p side panel dark through boot + the tuigreet greeter
  # (no flashbang; greeter stays on the 4K DP-1). Once sway owns KMS we clear it so the
  # connector hotplugs normally and the quick-settings panel can toggle it. Needs root
  # (writes the DRM sysfs `status` node), so sway calls it via scoped passwordless sudo.
  clearHdmiForce = pkgs.writeShellScriptBin "clear-hdmi-force" ''
    for s in /sys/class/drm/*-HDMI-A-2/status; do
      [ -w "$s" ] && echo detect > "$s"
    done
  '';
in {
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
        hdr.enable = true;
      };
      compression.enable = true;
      apps = {
        discord.enable = true;
        slack.enable = true;
        element.enable = false;
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

  # Boot console / greeter display (machine-specific).
  #  - video=HDMI-A-2:d keeps the 1080p side monitor dark through boot + the
  #    tuigreet login (the kernel console never lights it). sway still enables it
  #    on demand from the quick-settings panel — it does its own modesetting, so
  #    this only governs the kernel's own fbcon default, not what sway can drive.
  #  - Scale the console font up so the greeter is legible on the 4K DP-1. The
  #    greeter comes up on the 4K nvidia-drm console, so a large font is the fix;
  #    tuigreet is a centered TUI, so it's bigger/legible but not edge-to-edge.
  boot.kernelParams = ["video=HDMI-A-2:d"];
  console = {
    earlySetup = true;
    packages = [pkgs.terminus_font];
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
  };

  # sway/init.sh runs `clear-hdmi-force` at session start to lift the boot-time DRM force.
  # It writes a root-owned sysfs node, so grant passwordless sudo scoped to exactly that
  # one command — the /run path is a stable, exact match for the sudoers rule.
  environment.systemPackages = [clearHdmiForce];
  security.sudo.extraRules = [
    {
      users = [config.user.name];
      commands = [
        {
          command = "/run/current-system/sw/bin/clear-hdmi-force";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];
}
