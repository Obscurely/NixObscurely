{ lib
, stdenv
, fetchurl
, autoPatchelfHook
, ... # other dependencies if required
}:
let
  version = "1.6.7";
  pname = "codeium_language_server";

  platforms = {
    "x86_64-linux" = "linux_x64";
  };

  # Assuming we are focusing on x86_64-linux, you should generalize or adapt this
  platform = platforms.${stdenv.hostPlatform.system};

  # Example hash; you should replace it with the actual hash
  sha256 = "sha256-tnhfo84pUiiptPvyP0NKXkSiETedH7An1NAqbwI5Wvg=";

  src = fetchurl {
    # This URL should be adjusted based on version and platform
    url = "https://github.com/Exafunction/codeium/releases/download/language-server-v${version}/language_server_${platform}";
    inherit sha256;
  };
in
stdenv.mkDerivation {
  inherit pname version src;

  sourceRoot = ".";

  # Only use patchelf on Linux platforms
  nativeBuildInputs = lib.optional (!stdenv.isDarwin) autoPatchelfHook;

  # Override unpack phase as it's a binary, not an archive
  unpackPhase = "true";

  # Custom install phase
  installPhase = ''
    mkdir -p $out/bin
    install -m755 $src $out/bin/${pname}
  '';

  # Meta information
  meta = {
    description = "Codeium Language Server";
    homepage = "https://github.com/Exafunction/codeium";
    license = lib.licenses.mit; # Update according to the actual license
    platforms = lib.platforms.unix;
  };
}
