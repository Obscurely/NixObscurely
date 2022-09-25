{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop;
in {
  config = mkIf config.services.xserver.enable {
    assertions = [
      {
        assertion = (countAttrs (n: v: n == "enable" && value) cfg) < 2;
        message = "Can't have more than one desktop environment enabled at a time";
      }
      {
        assertion =
          let srv = config.services;
          in srv.xserver.enable ||
             srv.sway.enable ||
             !(anyAttrs
               (n: v: isAttrs v &&
                      anyAttrs (n: v: isAttrs v && v.enable))
               cfg);
        message = "Can't enable a desktop app without a desktop environment";
      }
    ];

    user.packages = with pkgs; [
      feh       # image viewer
      xclip
      xdotool
      xorg.xwininfo
      xorg.xinit
      xorg.libXcomposite
      xorg.libXinerama
      qgnomeplatform        # QPlatformTheme for a better Qt application inclusion in GNOME
      libsForQt5.qtstyleplugin-kvantum # SVG-based Qt5 theme engine plus a config tool and extra theme
      dialog # display dialog boxes from shell
      gnome.gnome-keyring # gnome's keyring
      newt
      lxde.lxsession # lightweight session manager
      sqlite # database
      usbutils # usb utilities
      xdg-user-dirs # create xdg user dirs
      picom # compositor
    ];

    fonts = {
      fontDir.enable = true;
      enableGhostscriptFonts = true;
      fonts = with pkgs; [
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
        SDL_ttf
        comfortaa
        (nerdfonts.override { 
          fonts = [ "FiraCode" "FiraMono" "DroidSansMono" "Hack" "Inconsolata" "Iosevka" "JetBrainsMono" "Meslo" "RobotoMono" "FantasqueSansMono" "Hermit" ];
        })
      ];
    };

    ## Apps/Services
    services.xserver.displayManager.lightdm.greeters.mini.user = config.user.name;

    programs.thunar = {
      enable = true;
      plugins = with pkgs.xfce; [ thunar-archive-plugin thunar-volman ];
    };
    programs.htop.enable = true;
    programs.java.enable = true;

    # Try really hard to get QT to respect my GTK theme.
    env.GTK_DATA_PREFIX = [ "${config.system.path}" ];
    env.QT_QPA_PLATFORMTHEME = "gnome";
    env.QT_STYLE_OVERRIDE = "kvantum";

    services.xserver.displayManager.sessionCommands = ''
      # GTK2_RC_FILES must be available to the display manager.
      export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
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
