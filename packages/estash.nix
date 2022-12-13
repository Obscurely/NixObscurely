{ stdenv, appimageTools, desktop-file-utils, fetchurl, my, ... }:

let
  version = "0.6.1";
  name = "estash-${version}";

  plat = {
    x86_64-linux = "";
  }.${stdenv.hostPlatform.system};

  sha256 = {
    x86_64-linux = "17a8a303b91f3b7dbcbdf77a42d62a7a5659027b87678f57adf3c3f5f2875aab";
  }.${stdenv.hostPlatform.system};

  src = fetchurl {
    url = "https://github.com/Obscurely/EStash/releases/download/v${version}-stable/estash-linux.AppImage";
    inherit sha256;
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in
appimageTools.wrapType2 rec {
  inherit name src;

  extraInstallCommands = ''
    mkdir -p $out/share/pixmaps $out/share/licenses/estash
    cp ${appimageContents}/estash.png $out/share/pixmaps/
    cp ${appimageContents}/EStash.desktop $out
    #cp ${appimageContents}/LICENSE.electron.txt $out/share/licenses/p3x-onenote/LICENSE
    mv $out/bin/${name} $out/bin/estash
    ${desktop-file-utils}/bin/desktop-file-install --dir $out/share/applications \
      --set-key Exec --set-value $out/bin/estash \
      --set-key Comment --set-value "EStash Linux" \
      --delete-original $out/EStash.desktop
  '';

  meta = {
    homepage = "https://github.com/Obscurely/EStash";
    description = "An open source, cross-platform, programmed in rust, encrypted digital vault (store files and text) with the capability to set a path and with the click of a button to copy the contents to that file";
    license = licenses.gpl3;
    maintainers = with maintainers; [ Obscurely ];
    platforms = platforms.linux;
  };
}
