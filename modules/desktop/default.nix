{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop;
  configDir = config.dotfiles.configDir;
in {
  config = mkIf config.services.xserver.enable {
    assertions = [
      {
        assertion = (countAttrs (n: v: n == "enable" && value) cfg) < 2;
        message = "Can't have more than one desktop environment enabled at a time";
      }
      {
        assertion = let
          srv = config.services;
        in
          srv.xserver.enable
          || srv.sway.enable
          || !(anyAttrs
            (n: v:
              isAttrs v
              && anyAttrs (n: v: isAttrs v && v.enable))
            cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];

    user.packages = with pkgs; [
      feh # image viewer
      betterlockscreen # lockscreen
      xclip
      xdotool
      xorg.xwininfo
      xorg.xinit
      xorg.libXcomposite
      xorg.libXinerama
      xorg.libxcb
      xorg.xkill
      qgnomeplatform # QPlatformTheme for a better Qt application inclusion in GNOME
      libsForQt5.qtstyleplugin-kvantum # SVG-based Qt5 theme engine plus a config tool and extra theme
      dialog # display dialog boxes from shell
      newt
      lxde.lxsession # lightweight session manager
      sqlite # database
      usbutils # usb utilities
      xdg-user-dirs # create xdg user dirs
      picom # compositor
      flameshot # cool utility for taking screen shots
      pkg-config # a tool for pkgs to find info about other pkgs
      ruby # for hey tool
    ];

    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      packages = with pkgs; [
        ubuntu_font_family
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
        xorg.fontxfree86type1
        noto-fonts-emoji
        # SDL_ttf # TODO: enable back when fixed
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
	hermit
      ];
    };

    ## Apps/Services
    services.xserver.displayManager.lightdm.greeters.mini.user = config.user.name;

    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [thunar-archive-plugin thunar-volman];
    };
    programs.htop.enable = true;

    # Try really hard to get QT to respect my GTK theme.
    env.GTK_DATA_PREFIX = ["${config.system.path}"];
    env.QT_QPA_PLATFORMTHEME = "gnome";
    env.QT_STYLE_OVERRIDE = "kvantum";

    services.xserver.displayManager.sessionCommands = ''
      # GTK2_RC_FILES must be available to the display manager.
      export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
    '';

    # Some crucial dotfiles
    home.configFile = with config.modules;
      mkMerge [
        {
          # Flameshot
          "flameshot".source = "${configDir}/flameshot";
        }
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

    # Disable ssh askpass
    programs.ssh.enableAskPassword = false;

    # Enable libinput
    services.libinput.enable = true;

    # Disable mouse acceleration
    services.libinput.mouse.accelProfile = "flat";
    services.libinput.mouse.accelSpeed = "0";

    # Enable gnome keyring service
    services.gnome.gnome-keyring.enable = true;

    # Enable xdg portal
    xdg.portal.enable = true;
    xdg.portal.config = {
      common = {
        default = [
          "gtk"
        ];
      };
    };
    xdg.portal.configPackages = [ pkgs.gnome-session ];

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

      # Create screenshots dir for flameshot

      if ! [ -d "Pictures/screenshots" ]; then
        mkdir -p ~/Pictures/screenshots
      fi

      # Create Code dir for programming

      if ! [ -d "Code" ]; then
        mkdir ~/Code
      fi

      # Install neovim configs

      if ! [ -d "Code" ]; then
        mkdir ~/Code
      fi

      if ! [ -d ".config/nvim/.git" ]; then
        mkdir -p ~/.config/nvim # create nvim dir .config in case the installer didn't
        git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1
        git clone https://github.com/Obscurely/neovim.git ~/.config/nvim/lua/custom
        arduino-cli config init
        arduino-cli core update-index
        arduino-cli core install arduino:avr
        arduino-cli  core update-index --additional-urls https://arduino.esp8266.com/stable/package_esp8266com_index.json
      fi

      # Load locckscreen image if there is one
      if [ -f "$XDG_DATA_HOME/lockscreen.jpg" ]; then
        betterlockscreen -u "$XDG_DATA_HOME/lockscreen.jpg" &
      fi
    '';

    # Clean up leftovers, as much as we can
    system.userActivationScripts.cleanupHome = ''
      pushd "${config.user.home}"
      rm -rf .compose-cache .nv .pki .dbus .fehbg
      [ -s .xsession-errors ] || rm -f .xsession-errors*
      popd
    '';
  };
}
