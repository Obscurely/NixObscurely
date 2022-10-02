# modules/desktop/media/graphics.nix

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.media.graphics;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.media.graphics = {
    enable         = mkBoolOpt false;
    tools.enable   = mkBoolOpt true;
    raster.enable  = mkBoolOpt true;
    vector.enable  = mkBoolOpt true;
    video.enable   = mkBoolOpt true;
    models.enable  = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs;
      (if cfg.tools.enable then [
        imagemagick    # for image manipulation from the shell
      ] else []) ++

      # replaces illustrator & indesign
      (if cfg.vector.enable then [
        unstable.inkscape
      ] else []) ++

      # Replaces photoshop
      (if cfg.raster.enable then [
        krita
        gimp-with-plugins
        gimpPlugins.resynthesizer  # content-aware scaling in gimp
      ] else []) ++

      # Replaces photoshop
      (if cfg.video.enable then [
        libsForQt5.kdenlive
      ] else []) ++

      # 3D modelling
      (if cfg.models.enable then [
        blender
      ] else []);

    home.configFile = mkIf cfg.raster.enable {
      "GIMP/2.10" = { source = "${configDir}/gimp"; recursive = true; };
    };
  };
}
