{
  lib,
  fetchurl,
  pkgs,
}:
let
  pname = "umo";
  version = "0.11";

  sevenZipMo =
    let
      src = fetchurl {
        url = "https://www.7-zip.org/a/7z2501-linux-x64.tar.xz";
        sha256 = "sha256-TKO3xvL2eGa5JiKBi1gjPccDZ74vNrSY6wveqqRLU/Q=";
      };
    in
    pkgs.stdenv.mkDerivation {
      pname = "7zmo";
      version = "2501";
      inherit src;

      nativeBuildInputs = [ pkgs.gnutar pkgs.xz ];

      unpackPhase = ''
        tar -xJf "$src"
      '';

      installPhase = ''
        mkdir -p "$out/bin"
        install -m755 7zz "$out/bin/7zmo"
        ln -s 7zmo "$out/bin/7z"
      '';
    };

  # Raw tes3cmd binary (PAR-packed Perl) — needs FHS libs at runtime, not its
  # own bwrap wrapper, because it will run inside umo's FHS sandbox.
  tes3cmdRaw =
    let
      source = import ../momw-tools-pack/source.nix;
      src = fetchurl {
        inherit (source) sha256 url;
        name = "momw-tools-pack-linux-${source.version}.tar.gz";
      };
    in
    pkgs.runCommand "tes3cmd-raw-${source.version}" { inherit src; } ''
      tmpdir="$(mktemp -d)"
      trap 'rm -rf "$tmpdir"' EXIT
      tar -xzf "$src" -C "$tmpdir"
      mkdir -p "$out/bin"
      binPath="$(find "$tmpdir" -maxdepth 3 -type f -name tes3cmd | head -n1)"
      install -m755 "$binPath" "$out/bin/tes3cmd"
    '';

  tarball = fetchurl {
    url = "https://gitlab.com/modding-openmw/umo/-/package_files/247516670/download";
    sha512 = "82fff0c215e7882676a59e5061b81d4c11af6eb27b3083049dc329c1e19a60a3dc2568113e94cba8cf2dc7c8686b662ef6f0cedf328e8e5d04d2b4f57de55fc2";
    name = "umo-source.tar.gz";
  };

  appimage = pkgs.stdenv.mkDerivation {
    name = "${pname}-extracted";
    src = tarball;

    unpackPhase = ''
      tar -xzf "$src"
    '';

    installPhase = ''
      mkdir -p "$out"
      find . -type f -name "umo" -executable -exec cp {} "$out/umo.AppImage" \;
    '';
  };

  appimageContents = pkgs.appimageTools.extractType2 {
    inherit pname version;
    src = "${appimage}/umo.AppImage";
  };
in
pkgs.appimageTools.wrapAppImage {
  inherit pname version;
  src = appimageContents;

  # These packages are available inside the FHS sandbox where umo runs.
  extraPkgs = pkgs: [
    tes3cmdRaw
    sevenZipMo
    pkgs.unrar
    # Libraries needed by tes3cmd's self-extracting PAR binary
    pkgs.libxcrypt-legacy
    pkgs.perl
    pkgs.zlib
  ];

  meta = {
    description = "umo is an automatic modlist downloader for Modding-OpenMW.com";
    homepage = "https://modding-openmw.gitlab.io/umo/";
    license = lib.licenses.agpl3Only;
    mainProgram = "umo";
    platforms = [ "x86_64-linux" ];
  };
}
