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
    sha256 = "161xslchmmj7k9p20hwij2gwmwyp7cm5glbigc2vn5lcnccd8ag4";
  };
in
pkgs.buildFHSUserEnv {
  name = "tes3cmd";
  targetPkgs = pkgs: [
    pkgs.libxcrypt-legacy
    pkgs.zlib
    pkgs.glibc
    pkgs.perl
  ];
  # runScript = "${src}";

  runScript = ''
    bash -c '
        cp ${momw-tools-pack}/ /tmp/tes3cmd
        chmod +x /tmp/tes3cmd
        exec /tmp/tes3cmd "$@"
        '
  '';
}
