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

  # Mont-Blanc-Dark GTK3 = adw-gtk3-dark (the proven Adwaita-for-GTK3) recolored to the
  # glacial palette. Shipped as a NAMED THEME (priority 200), NOT a ~/.config/gtk-3.0
  # user overlay (@800) — @200 is what keeps eww (itself a GTK3 app whose reset is @600)
  # immune while ordinary GTK3 apps still get fully themed. Built by copying adw-gtk3-dark's
  # gtk-3.0 (css + assets) and APPENDING our overlay to BOTH gtk.css and gtk-dark.css
  # (prefer-dark loads gtk-dark.css). See spec §12.
  montBlancGtk3 = pkgs.runCommand "Mont-Blanc-Dark" {} ''
    mkdir -p $out/gtk-3.0
    cp -r ${pkgs.adw-gtk3}/share/themes/adw-gtk3-dark/gtk-3.0/. $out/gtk-3.0/
    chmod -R u+w $out
    cat ${./config/Mont-Blanc-Dark/gtk-3.0/gtk.css} >> $out/gtk-3.0/gtk.css
    cat ${./config/Mont-Blanc-Dark/gtk-3.0/gtk.css} >> $out/gtk-3.0/gtk-dark.css
    cp ${./config/Mont-Blanc-Dark/index.theme} $out/index.theme
  '';
in {
  config = mkIf (cfg.active == "main") (mkMerge [
    # Desktop-agnostic configuration
    {
      modules = {
        theme = {
          wallpaper = mkDefault ./config/wallpaper.png;
          gtk = {
            theme = "Mont-Blanc-Dark";
            iconTheme = "Papirus-Dark";
            cursorTheme = "volantes_cursors";
          };
          fonts = {
            sans.name = "Fira Code";
            sans.size = 15;
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

      # Qt theming. platformTheme "qt5ct" installs BOTH the qt5ct + qt6ct plugins and sets
      # QT_QPA_PLATFORMTHEME=qt5ct; the qt6ct plugin also answers the "qt5ct" key, so Qt6
      # apps use it (there is no "qt6ct" platformTheme value in this nixpkgs). style
      # "kvantum" installs the qt5 + qt6 kvantum style plugins, sets QT_STYLE_OVERRIDE=
      # kvantum, and Kvantum itself drives the app PALETTE (not just widget rendering).
      # The Mont-Blanc-Dark Kvantum theme is installed to ~/.config/Kvantum below. (The old
      # "gtk2" platformTheme is dead — it needed a GTK2 palette, and the GTK2 layer was
      # dropped.) See spec §13.
      qt.enable = true;
      qt.platformTheme = "qt5ct";
      qt.style = "kvantum";

      # Other dotfiles
      home.configFile = with config.modules;
        mkMerge [
          {
            # Mont-Blanc-Dark GTK3 named theme (adw-gtk3-dark + glacial overlay, built
            # above). Deployed to ~/.themes/Mont-Blanc-Dark at THEME priority 200 so eww
            # stays immune. gtk-theme-name is set to "Mont-Blanc-Dark" by the base module
            # (gtk-*/settings.ini) + config/sway/init.sh (gsettings). See spec §12/§16.
            "../.themes/Mont-Blanc-Dark".source = montBlancGtk3;
          }
          {
            # GTK4 / libadwaita recolor — the single-file config-dir lever (libadwaita
            # ignores ~/.themes, so ~/.config/gtk-4.0/gtk.css @800 is the only reliable GTK4
            # lever). Per-file (not a whole-dir source) so nothing else under gtk-4.0 clashes.
            "gtk-4.0/gtk.css".source = ./config/Mont-Blanc-Dark/gtk-4.0/gtk.css;
          }
          {
            # Installation of the cursor theme
            "../.icons/volantes_cursors".source = ./config/volantes_cursors;
          }
          {
            # Kvantum (Qt) theme — Mont-Blanc-Dark (.kvconfig colors + .svg widget art).
            "Mont-Blanc-Dark-kvantum" = {
              recursive = true;
              source = ./config/Mont-Blanc-Dark/kde/kvantum/Mont-Blanc-Dark;
              target = "Kvantum/Mont-Blanc-Dark";
            };
            "kvantum.kvconfig" = {
              source = ./config/Mont-Blanc-Dark/kde/kvantum.kvconfig;
              target = "Kvantum/kvantum.kvconfig";
            };
          }
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
          {
            # Global btop: glacial theme + transparent bg (matches the desktop; the sysmon
            # widget's left-click btop uses it too). Recursive so btop can still write its log.
            "btop" = {
              source = ./config/btop;
              recursive = true;
            };
          }
        ];
    }
  ]);
}
