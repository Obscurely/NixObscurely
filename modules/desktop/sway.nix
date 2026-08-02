{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.sway;
  inherit (config.dotfiles) configDir;
in {
  options.modules.desktop.sway = {
    enable = mkBoolOpt false;
    host = mkOpt (with types; nullOr str) null;

    # Build the session with the Vulkan renderer + 10-bit framebuffers (needed
    # for HDR). Defaults false -> GLES2 path, which is the safe first-boot route
    # on NVIDIA. Flip true only once a plain session is confirmed working.
    hdr.enable = mkBoolOpt false;

    bar.enable = mkBoolOpt true;
    greeter.enable = mkBoolOpt true;
    idle.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable (mkMerge [
    ##########################################################################
    ## Compositor
    ##########################################################################
    {
      programs.sway = {
        enable = true;
        wrapperFeatures.gtk = true;

        # These exports live in the sway *wrapper* the session launches, so they
        # reach sway AND every child it spawns -- even under greetd, which does
        # not source /etc/profile. This is why the Wayland env vars go here and
        # not in the config's `env` mechanism (that one relies on extraInit).
        extraSessionCommands =
          ''
            export XDG_CURRENT_DESKTOP=sway
            export XDG_SESSION_TYPE=wayland
            export XDG_SESSION_DESKTOP=sway

            # Silence sway's harmless "Proprietary Nvidia drivers are in use"
            # warning (runs fine on the open modules + Vulkan). Equivalent to
            # passing `--unsupported-gpu`, but without touching the greetd --cmd
            # quoting.
            export SWAY_UNSUPPORTED_GPU=true

            # Chromium/Electron native Wayland; Qt prefers Wayland, falls back to xcb.
            export NIXOS_OZONE_WL=1
            export QT_QPA_PLATFORM="wayland;xcb"
            export MOZ_ENABLE_WAYLAND=1
            export _JAVA_AWT_WM_NONREPARENTING=1

            # Cursor for Xwayland clients. Base 24 — sway multiplies by each
            # output's scale (24 -> 36 on the 4K@1.5), so do NOT pre-scale here.
            export XCURSOR_SIZE=24
            export XCURSOR_THEME=volantes_cursors
          ''
          + optionalString cfg.hdr.enable ''
            export WLR_RENDERER=vulkan
          '';
      };

      # services.libinput only configures the X11 input driver; Wayland sway
      # talks to libinput directly (input config lives in the sway config file).
      services.libinput.enable = mkForce false;

      # Screencast (OBS, browser/Discord screen share) + GTK file-chooser portal.
      xdg.portal = {
        enable = true;
        wlr.enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gtk];
        config.common.default = ["wlr" "gtk"];
      };

      security.polkit.enable = true;
      # Let swaylock authenticate against PAM (otherwise it can never unlock).
      security.pam.services.swaylock = {};

      programs.dconf.enable = true;
      services.gvfs.enable = true; # trash / mounts in Thunar
      services.tumbler.enable = true; # thumbnails in file managers

      user.packages = with pkgs; [
        # --- session ---
        swaylock
        swayidle
        swaybg
        lxqt.lxqt-policykit # graphical polkit agent (lxqt-policykit-agent)

        # --- clipboard ---
        wl-clipboard
        cliphist

        # --- screenshots (replaces flameshot) ---
        grim
        slurp
        satty

        # --- notifications ---
        mako

        # --- utilities ---
        wev # xev equivalent (debug keybinds)
        wtype # xdotool type equivalent
        wlr-randr # one-off output queries
        imv # image viewer (feh/ristretto)
        libnotify # notify-send
        playerctl
        pavucontrol
        wf-recorder
        jq # used by a couple of sway keybinds
        glib # gsettings/gio (theme for GTK4/libadwaita apps, via init.sh)
      ];

      # Qt theming (QT_QPA_PLATFORMTHEME) is owned by modules/themes/main.

      modules.theme.onReload.sway = "${pkgs.sway}/bin/swaymsg reload";
    }

    ##########################################################################
    ## Config files
    ##########################################################################
    {
      home.configFile = mkMerge [
        {
          "sway" = {
            source = "${configDir}/sway";
            recursive = true;
          };
        }
        {"mako/config".source = "${configDir}/mako/config";}
        {"satty/config.toml".source = "${configDir}/satty/config.toml";}
      ];
    }

    ##########################################################################
    ## Bar
    ##########################################################################
    (mkIf cfg.bar.enable {
      # eww "glacial island" bar; config + scripts installed by modules/themes/main.
      # Runtime deps are already in user.packages above: jq, playerctl, swaymsg (sway),
      # and pactl (from the system PipeWire/Pulse). cava feeds the media-widget visualizer.
      user.packages = [pkgs.eww pkgs.cava];
    })

    ##########################################################################
    ## Greeter
    ##########################################################################
    (mkIf cfg.greeter.enable {
      # gnome-keyring is enabled in desktop/default.nix, but the greetd PAM
      # stack must be told to unlock it at login (Secret Service: NM secrets,
      # app credentials, pinentry). programs.sway does not wire this.
      security.pam.services.greetd.enableGnomeKeyring = true;

      services.greetd = {
        enable = true;
        settings.default_session = {
          command = concatStringsSep " " [
            "${pkgs.tuigreet}/bin/tuigreet"
            "--time"
            "--remember"
            "--remember-user-session"
            "--asterisks"
            "--cmd sway"
          ];
          user = "greeter";
        };
      };

      # Keep kernel messages from scribbling over the greeter tty.
      systemd.services.greetd.serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal";
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
    })
  ]);
}
