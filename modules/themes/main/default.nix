# modules/themes/main/default.nix --- a regal dracula-inspired theme
{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.theme;
  configDir = config.dotfiles.configDir;
in {
  config = mkIf (cfg.active == "main") (mkMerge [
    # Desktop-agnostic configuration
    {
      modules = {
        theme = {
          wallpaper = mkDefault ./config/wallpaper.png;
          gtk = {
            theme = "Fluent-Dark";
            iconTheme = "Papirus-Dark";
            cursorTheme = "volantes_cursors";
          };
          fonts = {
            sans.name = "Fira Sans";
            mono.name = "Fira Code";
          };
          colors = {
            black = "#1E2029";
            red = "#ffb86c";
            green = "#50fa7b";
            yellow = "#f0c674";
            blue = "#61bfff";
            magenta = "#bd93f9";
            cyan = "#8be9fd";
            silver = "#e2e2dc";
            grey = "#5B6268";
            brightred = "#de935f";
            brightgreen = "#0189cc";
            brightyellow = "#f9a03f";
            brightblue = "#8be9fd";
            brightmagenta = "#ff79c6";
            brightcyan = "#0189cc";
            white = "#f8f8f2";

            types.fg = "#bbc2cf";
            types.panelbg = "#21242b";
            types.border = "#1a1c25";
          };
        };

        desktop.browsers = {
          librewolf.userChrome = concatMapStringsSep "\n" readFile [
            ./config/librewolf/userChrome.css
          ];
          qutebrowser.userStyles =
            concatMapStringsSep "\n" readFile
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
        papirus-icon-theme
      ];
      fonts = {
        packages = with pkgs; [
          fira-code
          fira-code-symbols
          open-sans
          jetbrains-mono
          siji
          font-awesome
        ];
      };

      # Login screen theme
      services.xserver.displayManager.lightdm.greeters.mini.extraConfig = ''
        text-color = "${cfg.colors.magenta}"
        password-background-color = "${cfg.colors.black}"
        window-color = "${cfg.colors.types.border}"
        border-color = "${cfg.colors.types.border}"
      '';

      # Get qt to look similar to the gtk apps
      qt.enable = true;
      qt.platformTheme = "gtk2";
      qt.style = "gtk2";

      # Other dotfiles
      home.configFile = with config.modules;
        mkMerge [
          {
            # Installation of the gtk theme
            "../.themes/Fluent-Dark".source = ./config/Fluent-Dark;
          }
          {
            # Make gtk themes work with libadwaita
            "gtk-4.0".source = ./config/Fluent-Dark/gtk-4.0;
          }
          {
            # Installation of the cursor theme
            "../.icons/volantes_cursors".source = ./config/volantes_cursors;
          }
          {
            # Sourced from sessionCommands in modules/themes/default.nix
            "xtheme/90-theme".source = ./config/Xresources;
          }
          {
            # Additional file to load when coding (to remove the borders in xst)
            "xtheme/90.b-theme".source = ./config/Xresources_code;
          }
          {
            # Haruna theme
            "harunarc".source = ./config/harunarc;
          }
          (mkIf desktop.bspwm.enable {
            "bspwm/rc.d/00-theme".source = ./config/bspwmrc;
            "bspwm/rc.d/95-polybar".source = ./config/polybar/run.sh;
          })
          (mkIf desktop.apps.rofi.enable {
            "rofi/theme" = {
              source = ./config/rofi;
              recursive = true;
            };
          })
          (mkIf (desktop.bspwm.enable) {
            "polybar" = {
              source = ./config/polybar;
              recursive = true;
            };
            "Fluent-Dark-kvantum" = {
              recursive = true;
              source = ./config/Fluent-Dark/kde/kvantum/Fluent-Dark;
              target = "Kvantum/Fluent-Dark";
            };
            "kvantum.kvconfig" = {
              source = ./config/Fluent-Dark/kde/kvantum.kvconfig;
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
