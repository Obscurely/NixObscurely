# modules/themes/main/default.nix --- a regal dracula-inspired theme

{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.theme;
in {
  config = mkIf (cfg.active == "main") (mkMerge [
    # Desktop-agnostic configuration
    {
      modules = {
        theme = {
          wallpaper = mkDefault ./config/wallpaper.png;
          gtk = {
            theme = "Orchis-Dark";
            iconTheme = "Papirus-Dark";
            cursorTheme = "Capitaine Cursors";
          };
          fonts = {
            sans.name = "Fira Sans";
            mono.name = "Fira Code";
          };
          colors = {
            black         = "#1E2029";
            red           = "#ffb86c";
            green         = "#50fa7b";
            yellow        = "#f0c674";
            blue          = "#61bfff";
            magenta       = "#bd93f9";
            cyan          = "#8be9fd";
            silver        = "#e2e2dc";
            grey          = "#5B6268";
            brightred     = "#de935f";
            brightgreen   = "#0189cc";
            brightyellow  = "#f9a03f";
            brightblue    = "#8be9fd";
            brightmagenta = "#ff79c6";
            brightcyan    = "#0189cc";
            white         = "#f8f8f2";

            types.fg      = "#bbc2cf";
            types.panelbg = "#21242b";
            types.border  = "#1a1c25";
          };
        };

        desktop.browsers = {
          firefox.userChrome = concatMapStringsSep "\n" readFile [
            ./config/firefox/userChrome.css
          ];
          qutebrowser.userStyles = concatMapStringsSep "\n" readFile
            (map toCSSFile [
              ./config/qutebrowser/userstyles/monospace-textareas.scss
              ./config/qutebrowser/userstyles/stackoverflow.scss
              ./config/qutebrowser/userstyles/xkcd.scss
            ]);
        };
      };
    }

    # Desktop (X11) theming
    (mkIf config.services.xserver.enable {
      user.packages = with pkgs; [
        unstable.orchis-theme
        papirus-icon-theme 
        capitaine-cursors
      ];
      fonts = {
        fonts = with pkgs; [
          fira-code
          fira-code-symbols
          open-sans
          jetbrains-mono
          siji
          font-awesome
        ];
      };

      # Compositor
      # services.picom = {
      #   fade = false;
      #   fadeDelta = 1;
      #   fadeSteps = [ 0.01 0.012 ];
      #   shadow = true;
      #   shadowOffsets = [ (-10) (-10) ];
      #   shadowOpacity = 0.22;
      #   # activeOpacity = "1.00";
      #   # inactiveOpacity = "0.92";
      #   settings = {
      #     shadow-radius = 12;
      #     # blur-background = true;
      #     # blur-background-frame = true;
      #     # blur-background-fixed = true;
      #     blur-kern = "7x7box";
      #     blur-strength = 320;
      #   };
      # };

      # Login screen theme
      services.xserver.displayManager.lightdm.greeters.mini.extraConfig = ''
        text-color = "${cfg.colors.magenta}"
        password-background-color = "${cfg.colors.black}"
        window-color = "${cfg.colors.types.border}"
        border-color = "${cfg.colors.types.border}"
      '';

      # Other dotfiles
      home.configFile = with config.modules; mkMerge [
        {
          # Sourced from sessionCommands in modules/themes/default.nix
          "xtheme/90-theme".source = ./config/Xresources;
        }
        (mkIf desktop.bspwm.enable {
          "bspwm/rc.d/00-theme".source = ./config/bspwmrc;
          "bspwm/rc.d/95-polybar".source = ./config/polybar/run.sh;
        })
        (mkIf desktop.apps.rofi.enable {
          "rofi/theme" = { source = ./config/rofi; recursive = true; };
        })
        (mkIf (desktop.bspwm.enable) {
          "polybar" = { source = ./config/polybar; recursive = true; };
          "Orchis-Dark-kvantum" = {
            recursive = true;
            source = "${pkgs.unstable.orchis-theme}/share/themes/Orchis-Dark/kde/kvantum/Orchis-Dark";
            target = "Kvantum/Orchis-Dark";
          };
          "kvantum.kvconfig" = {
            text = "theme=Orchis-Dark";
            target = "Kvantum/kvantum.kvconfig";
          };
        })
        (mkIf desktop.media.graphics.vector.enable {
          "inkscape/templates/default.svg".source = ./config/inkscape/default-template.svg;
        })
        (mkIf desktop.browsers.qutebrowser.enable {
          "qutebrowser/extra/theme.py".source = ./config/qutebrowser/theme.py;
        })
      ];
    })
  ]);
}
