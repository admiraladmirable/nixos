{
  lib,
  stdenv,
  fetchurl,
  libxcrypt-legacy,
  libgcc,
  zlib,
  autoPatchelfHook,
  source ? import ./source.nix,
}:

stdenv.mkDerivation {
  pname = "momw-tools-pack";
  inherit (source) version;
  sourceRoot = ".";

  src = fetchurl {
    inherit (source) sha256 url;
    name = "momw-tools-pack-linux-${source.version}.tar.gz";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    libgcc
    libxcrypt-legacy
    zlib
  ];

  runtimeDependencies = map lib.getLib [
    libgcc
    libxcrypt-legacy
    zlib
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin

    for f in \
      delta_plugin \
      groundcoverify \
      momw-configurator-linux-amd64 \
      openmw-validator-linux-amd64 \
      s3lightfixes \
      tes3cmd \
      umo
    do
      if [[ -x "$f" && -f "$f" ]]; then
        install -m755 "$f" "$out/bin/$f"
      fi
    done

    runHook postInstall
  '';

  meta = {
    description = "Metapackage with all the tools needed to automatically install and configure Modding-OpenMW.com modlists.";
    homepage = "https://modding-openmw.gitlab.io/momw-tools-pack/";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "momw-tools-pack";
    platforms = [ "x86_64-linux" ];
  };
}
