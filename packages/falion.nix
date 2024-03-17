{ lib, stdenv, fetchTarball, makeDesktopItem, makeWrapper }:

let
  version = "1.0.0";
  name = "falion-${version}";

  src = fetchTarball {
    url = "https://github.com/Obscurely/falion/releases/download/v${version}-stable/falion-linux.tar.gz";
    # Please replace <hash> with the correct hash for the tarball
    sha256 = "301ae741284e64f5d42155ff459c1ac517d018f25c538edc224eefb8bbf5f53e";
  };
  
in stdenv.mkDerivation {
  inherit name src;

  buildInputs = [ makeWrapper ];

  dontBuild = true; # Assuming there's no build process required as we're just repackaging binaries

  installPhase = ''
    mkdir -p $out/bin $out/share/pixmaps $out/share/licenses/falion

    # Assuming the tarball structure is similar and binaries, icons, and .desktop files are located similarly as they were in the AppImage
    cp falion $out/bin/falion
    cp linux/desktop/icons/512x512/apps/falion.png $out/share/pixmaps/falion.png
    cp LICENSE $out/share/licenses/falion/LICENSE

    # Update paths and install desktop entry (adjust paths as necessary)
    # Note: Adjust `Exec`, `Icon`, and other relevant paths in falion.desktop if needed
    makeDesktopItem {
      name = "falion";
      exec = "$out/bin/falion"; # Adjust the executable path if needed
      icon = "$out/share/pixmaps/falion.png"; # Adjust icon path if necessary
      desktopName = "Falion";
      genericName = "Falion";
      categories = "Utility;";
    } > $out/share/applications/falion.desktop

    # Adjust permissions if necessary
    chmod +x $out/bin/*
  '';

  meta = {
    homepage = "https://github.com/Obscurely/falion";
    description = "An open source, programmed in rust, privacy focused tool for scraping programming resources (like stackoverflow) fast, efficient and asynchronous/parallel using the CLI or GUI. ";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Obscurely ];
    platforms = lib.platforms.linux;
  };
}
