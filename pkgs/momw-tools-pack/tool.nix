{
  lib,
  stdenv,
  fetchurl,
  autoPatchelfHook,
  libgcc,
  libxcrypt-legacy,
  zlib,
  binaryName,
  packageName ? binaryName,
  extraBinaryNames ? [ ],
  wrapWithLdLibraryPath ? false,
  source ? import ./source.nix,
}:

stdenv.mkDerivation {
  pname = packageName;
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

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    ${if wrapWithLdLibraryPath then ''
      mkdir -p "$out/libexec/${packageName}"
      install -m755 "${binaryName}" "$out/libexec/${packageName}/${binaryName}"
      cat > "$out/bin/${packageName}" <<EOF
      #!${stdenv.shell}
      export LD_LIBRARY_PATH="${lib.makeLibraryPath [ libgcc libxcrypt-legacy zlib ]}"''${LD_LIBRARY_PATH:+:''${LD_LIBRARY_PATH}}
      exec "$out/libexec/${packageName}/${binaryName}" "$@"
      EOF
      chmod +x "$out/bin/${packageName}"
    '' else ''
      install -m755 "${binaryName}" "$out/bin/${packageName}"
    ''}
    for alias in ${lib.concatStringsSep " " extraBinaryNames}; do
      ln -sf "${packageName}" "$out/bin/$alias"
    done

    runHook postInstall
  '';

  meta = {
    description = "Tool from the Modding-OpenMW tools pack: ${packageName}";
    homepage = "https://modding-openmw.gitlab.io/momw-tools-pack/";
    license = lib.licenses.gpl3;
    mainProgram = packageName;
    platforms = [ "x86_64-linux" ];
  };
}
