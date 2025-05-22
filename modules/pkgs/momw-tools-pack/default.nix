{
  lib,
  stdenv,
  fetchurl,
  pkgs,
  libxcrypt-legacy,
  patchelf,
  autoPatchelfHook,
  makeWrapper,
}:
let
  momw-tools-pack = fetchurl {
    url = "https://gitlab.com/api/v4/projects/modding-openmw%2Fmomw-tools-pack/jobs/artifacts/master/raw/momw-tools-pack-linux.tar.gz?job=make";
    sha256 = "sha256-Xqqc6HYqrIw3hxM90pNeOMJMAxu+b925wkWYt534rs8=";
  };
in
stdenv.mkDerivation rec {
  pname = "momw-tools-pack";
  version = "0.1.0";

  src = momw-tools-pack;

  nativeBuildInputs = [
    autoPatchelfHook
  ];

  buildInputs = [
    # libxcrypt-legacy
  ];

  sourceRoot = ".";

  installPhase = ''
    runHook preInstall

    for f in \
      delta_plugin \
      groundcoverify \
      momw-configurator-linux-amd64 \
      openmw-validator-linux-amd64 \
      s3lightfixes \
      tes3cmd \
      umo
    do
      src_path="momw-tools-pack-linux/$f"
      if [[ -x "$src_path" && -f "$src_path" ]]; then
        install -m755 "$src_path" "$out/bin/$f"
      fi
    done

    file "delta_plugin"
    ldd "delta_plugin"

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://modding-openmw.gitlab.io/momw-tools-pack/";
    description = "momw-tools-pack";
    platforms = platforms.linux;
  };
}
