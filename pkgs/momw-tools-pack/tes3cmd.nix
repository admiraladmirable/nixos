{
  pkgs,
  fetchurl,
  source ? import ./source.nix,
}:
let
  src = fetchurl {
    inherit (source) sha256 url;
    name = "momw-tools-pack-linux-${source.version}.tar.gz";
  };

  tes3cmdBin = pkgs.runCommand "tes3cmd-bin-${source.version}" { inherit src; } ''
    tmpdir="$(mktemp -d)"
    trap 'rm -rf "$tmpdir"' EXIT
    tar -xzf "$src" -C "$tmpdir"
    mkdir -p "$out"
    binPath="$(find "$tmpdir" -maxdepth 3 -type f -name tes3cmd | head -n1)"
    install -m755 "$binPath" "$out/tes3cmd"
  '';
in
pkgs.buildFHSEnv {
  name = "tes3cmd";
  targetPkgs = pkgs: [
    pkgs.glibc
    pkgs.libxcrypt-legacy
    pkgs.perl
    pkgs.zlib
  ];
  runScript = "${tes3cmdBin}/tes3cmd";
}
