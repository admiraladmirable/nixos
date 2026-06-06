{
  stdenv,
  lib,
  pkgs,
  dpkg,
  openssl,
  libnl,
  zlib,
  autoPatchelfHook,
  buildFHSEnv,
  requireFile,
  ...
}:
let
  pname = "falcon-sensor";
  version = "7.32.0-18504";
  arch = "amd64";
  # Proprietary, unredistributable .deb — kept out of git and the flake source.
  # requireFile references it by hash from the nix store, so pure eval works
  # (no --impure). Populate the store once with:
  #   nix-store --add-fixed sha256 falcon-sensor_${version}_${arch}.deb
  src = requireFile {
    name = "${pname}_${version}_${arch}.deb";
    hash = "sha256-DDrBLnSWR80FqOi9YoFUHluoSWyhugQu2mY39UfbXcA=";
    message = ''
      CrowdStrike Falcon Sensor .deb is not in the nix store.
      Download it from the CrowdStrike console, then add it:
        nix-store --add-fixed sha256 ${pname}_${version}_${arch}.deb
    '';
  };
  falcon-sensor = stdenv.mkDerivation {
    inherit version arch src;
    name = pname;

    buildInputs = [
      dpkg
      zlib
      autoPatchelfHook
    ];

    sourceRoot = ".";

    unpackPhase = ''
      dpkg-deb -x $src .
    '';

    installPhase = ''
      cp -r . $out
    '';

    meta = with lib; {
      description = "Crowdstrike Falcon Sensor";
      homepage = "https://www.crowdstrike.com/";
      license = licenses.unfree;
      platforms = platforms.linux;
    };
  };
in
buildFHSEnv {
  name = "fs-bash";
  targetPkgs = pkgs: [
    libnl
    openssl
    zlib
  ];

  extraInstallCommands = ''
    ln -s ${falcon-sensor}/* $out/
  '';

  runScript = "bash";
}
