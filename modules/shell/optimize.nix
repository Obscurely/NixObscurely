# Tools for optimizing files
{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.optimize;
in {
  options.modules.shell.optimize = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      gifsicle # optimize gifs
      optipng # optimize png
      pngquant # optimize png
      jpegoptim # optimize jpeg
      ghostscript # optimize pdf
      bc # for optimizing photos
      nodePackages.svgo # svg cleaning
      svgcleaner # svg cleaning
	  libwebp # for cwebp and dwebp
	  libavif # for avif
	  advancecomp # for advpng
	  pngcrush # for png
	  jpeg-archive # for jpeg-recompress
    ];

    programs.adb.enable = true;
  };
}
