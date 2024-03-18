{ lib, stdenv, appimageTools, desktop-file-utils, fetchurl }:

let
  version = "1.0.2";
  name = "falion-${version}";

  plat = {
    x86_64-linux = "";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    x86_64-linux = "418efba269d49f02e259de8f631809a73e266ab6facc312b49f65699e16e1071";
  }.${stdenv.hostPlatform.system};

  src = fetchurl {
    url = "https://github.com/Obscurely/falion/releases/download/v${version}-stable/falion-linux.AppImage";
    inherit sha256;
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in
appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    mkdir -p $out/share/pixmaps $out/share/licenses/falion
    cp ${appimageContents}/falion.png $out/share/pixmaps/
    cp ${appimageContents}/falion.desktop $out
    cp ${appimageContents}/LICENSE $out/share/licenses/falion/LICENSE
    mv $out/bin/${name} $out/bin/falion
    ${desktop-file-utils}/bin/desktop-file-install --dir $out/share/applications \
      --set-key Exec --set-value $out/bin/falion \
      --set-key Comment --set-value "falion Linux" \
      --delete-original $out/falion.desktop
  '';

  meta = {
    homepage = "https://github.com/Obscurely/falion";
    description = "An open source, programmed in rust, privacy focused tool for scraping programming resources (like stackoverflow) fast, efficient and asynchronous/parallel using the CLI or GUI. ";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
}
