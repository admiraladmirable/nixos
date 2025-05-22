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
  tes3cmdBin = fetchurl {
    url = "https://modding-openmw.com/files/tes3cmd-0.37w.linux.x86_64";
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
        cp ${tes3cmdBin} /tmp/tes3cmd
        chmod +x /tmp/tes3cmd
        exec /tmp/tes3cmd "$@"
        '
  '';
}
# }
# stdenv.mkDerivation
# {
#   name = "tes3cmd";
#   src = fetchurl {
#     url = "https://modding-openmw.com/files/tes3cmd-0.37w.linux.x86_64";
#     sha256 = "161xslchmmj7k9p20hwij2gwmwyp7cm5glbigc2vn5lcnccd8ag4";
#   };
#   phases = [
#     "installPhase"
#     "patchPhase"
#   ];
#   nativeBuildInputs = [
#     patchelf
#   ];
#   buildInputs = [ pkgs.libxcrypt-legacy ];
#   # runtimeDependencies = map lib.getLib [
#   #   libxcrypt-legacy
#   # ];
#
#   # autoPatchelfIgnoreMissingDeps = [ "libcrypt.so.1" ];
#   installPhase = ''
#
#       mkdir -p $out/bin
#       install -m755 $src ./tes3cmd
#     chmod +w ./tes3cmd
#
#       patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
#              --set-rpath ${lib.makeLibraryPath [ libxcrypt-legacy ]} \
#              ./tes3cmd
#
#
#       mv ./tes3cmd $out/bin/
#   '';
# }
