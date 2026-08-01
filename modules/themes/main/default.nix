# modules/themes/main/default.nix --- a regal dracula-inspired theme
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.theme;
  inherit (config.dotfiles) configDir;
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
            sans.name = "Fira Code";
            sans.size = 17;
            mono.name = "Fira Code";
            mono.size = 18;
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
      };
    }

    # Theming (Wayland/sway)
    {
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

      # Qt theming: platformTheme "gtk2" makes Qt pull palette/fonts/icons from
      # the GTK (Fluent-Dark) theme; style "kvantum" makes Qt widgets use the
      # installed Kvantum Fluent-Dark theme (QT_STYLE_OVERRIDE=kvantum + the
      # qtstyleplugin-kvantum plugins for qt5 & qt6). The Kvantum theme files are
      # installed to ~/.config/Kvantum below.
      qt.enable = true;
      qt.platformTheme = "gtk2";
      qt.style = "kvantum";

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
            # Haruna theme
            "harunarc".source = ./config/harunarc;
          }
          {
            # Kvantum (Qt) theme
            "Fluent-Dark-kvantum" = {
              recursive = true;
              source = ./config/Fluent-Dark/kde/kvantum/Fluent-Dark;
              target = "Kvantum/Fluent-Dark";
            };
            "kvantum.kvconfig" = {
              source = ./config/Fluent-Dark/kde/kvantum.kvconfig;
              target = "Kvantum/kvantum.kvconfig";
            };
          }
          (mkIf desktop.apps.rofi.enable {
            "rofi/theme" = {
              source = ./config/rofi;
              recursive = true;
            };
          })
          (mkIf desktop.sway.bar.enable {
            # eww "glacial island" bar — eww.yuck + eww.scss + scripts/
            "eww" = {
              source = ./config/eww;
              recursive = true;
            };
          })
          (mkIf desktop.media.graphics.vector.enable {
            "inkscape/templates/default.svg".source = ./config/inkscape/default-template.svg;
          })
        ];
    }
  ]);
}
