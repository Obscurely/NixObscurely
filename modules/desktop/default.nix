{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop;
  inherit (config.dotfiles) configDir;
in {
  # Shared graphical config. Sway/Wayland is the only desktop, so this keys off
  # the sway option.
  config = mkIf config.modules.desktop.sway.enable (mkMerge [
    {
      assertions = [
        {
          assertion = (countAttrs (n: v: n == "enable" && value) cfg) < 2;
          message = "Can't have more than one desktop environment enabled at a time";
        }
        {
          assertion =
            config.programs.sway.enable
            || !(anyAttrs
              (n: v:
                isAttrs v
                && anyAttrs (n: v: isAttrs v && v.enable))
              cfg);
          message = "Can't enable a desktop app without a desktop environment";
        }
      ];

      user.packages = with pkgs; [
        qgnomeplatform # QPlatformTheme for better Qt integration
        kdePackages.qtstyleplugin-kvantum # SVG-based Qt theme engine
        dialog # display dialog boxes from shell
        newt
        sqlite # database
        usbutils # usb utilities
        xdg-user-dirs # create xdg user dirs
        pkg-config # a tool for pkgs to find info about other pkgs
        ruby # for hey tool
      ];

      fonts = {
        fontDir.enable = true;
        enableGhostscriptFonts = true;
        packages = with pkgs; [
          ubuntu-classic
          symbola
          corefonts
          liberation_ttf
          ttf_bitstream_vera
          dejavu_fonts
          terminus_font
          bakoma_ttf
          clearlyU
          cm_unicode
          andagii
          freefont_ttf
          bakoma_ttf
          inconsolata
          gentium
          source-sans-pro
          wineWowPackages.fonts
          source-code-pro
          noto-fonts
          powerline-fonts
          fira-code
          font-awesome
          hack-font
          roboto
          noto-fonts-color-emoji
          stable.SDL_ttf
          comfortaa
          # Nerd fonts
          nerd-fonts.fira-code
          nerd-fonts.fira-mono
          nerd-fonts.droid-sans-mono
          nerd-fonts.hack
          nerd-fonts.inconsolata
          nerd-fonts.iosevka
          nerd-fonts.jetbrains-mono
          nerd-fonts.meslo-lg
          nerd-fonts.roboto-mono
          nerd-fonts.fantasque-sans-mono
          nerd-fonts.hurmit
          nerd-fonts.sauce-code-pro
          hermit
        ];
      };

      programs.thunar = {
        enable = true;
        plugins = with pkgs; [thunar-archive-plugin thunar-volman];
      };
      programs.htop.enable = true;

      # Try really hard to get QT to respect my GTK theme.
      env.GTK_DATA_PREFIX = ["${config.system.path}"];

      # Some crucial dotfiles
      home.configFile = mkMerge [
        {
          # Mimeapps list
          "mimeapps.list".source = "${configDir}/mimeapps.list";
        }
        {
          # User dir config
          "user-dirs.dirs".source = "${configDir}/user-dirs/user-dirs.dirs";
          "user-dirs.locale".source = "${configDir}/user-dirs/user-dirs.locale";
        }
      ];

      # disable ssh askpass
      programs.ssh.enableAskPassword = false;

      # Enable gnome keyring service
      services.gnome.gnome-keyring.enable = true;

      # xdg portal is enabled + configured (wlr+gtk) in modules/desktop/sway.nix.

      # Enable upower
      services.upower.enable = true;

      # Run activation script for setting the user up
      # Create xdg folders, install neovim config etc.
      system.userActivationScripts.setupUser = ''
        # cd into home dir just to make sure
        cd ~

        # Create xdg-user-dirs

        if ! [ -d "Desktop" ]; then
          mkdir ~/Desktop
        fi

        if ! [ -d "Documents" ]; then
          mkdir ~/Documents
        fi
        if ! [ -d "Downloads" ]; then
          mkdir ~/Downloads
        fi

        if ! [ -d "Music" ]; then
          mkdir ~/Music
        fi

        if ! [ -d "Pictures" ]; then
          mkdir ~/Pictures
        fi

        if ! [ -d "Videos" ]; then
          mkdir ~/Videos
        fi

        # Create screenshots dir

        if ! [ -d "Pictures/screenshots" ]; then
          mkdir -p ~/Pictures/screenshots
        fi

        # Create Code dir for programming

        if ! [ -d "Code" ]; then
          mkdir ~/Code
        fi

        # Install neovim configs

        if ! [ -d ".config/nvim/.git" ]; then
          mkdir -p ~/.config/nvim # create nvim dir .config in case the installer didn't
          git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
          git clone https://github.com/Obscurely/neovim.git ~/.config/nvim/lua/custom
          arduino-cli config init
          arduino-cli core update-index
          arduino-cli core install arduino:avr
          arduino-cli  core update-index --additional-urls https://arduino.esp8266.com/stable/package_esp8266com_index.json
        fi
      '';

      # Clean up leftovers, as much as we can
      system.userActivationScripts.cleanupHome = ''
        pushd "${config.user.home}"
        rm -rf .compose-cache .nv .pki .dbus
        popd
      '';
    }
  ]);
}
