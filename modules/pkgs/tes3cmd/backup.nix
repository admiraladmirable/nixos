{
  python3Packages,
  fetchFromGitLab,
  lib,
  pkgs,
}:
python3Packages.buildPythonApplication rec {
  pname = "tes3cmd";
  version = "91f7e332a04750c88a32bc95833aa5016666a63b";

  src = fetchFromGitLab {
    owner = "modding-openmw";
    repo = "tes3cmd";
    rev = version;
    sha256 = "91f7e332a04750c88a32bc95833aa5016666a63b";
  };

  # pyproject = true;
  #
  # build-system = with python3Packages; [
  #   setuptools
  # ];
  # dependencies = with python3Packages; [
  #   coloredlogs
  #   desktop-notifier
  #   pkgs.openmw-nix.curldl
  #   pkgs.desktop-file-utils
  #   pycurl
  #   pydantic
  #   pycryptodomex
  #   platformdirs
  #   rarfile
  #   pwinput
  #   websockets
  #   certifi
  #   beautifulsoup4
  # ];
  #
  # pythonRelaxDeps = true;

  nativeInstallCheckInputs = [ pkgs.versionCheckHook ];
  versionCheckProgramArg = "--version";
  doInstallCheck = true;
  installCheckPhase = ''
    # have to import hook manually, something is broken for automatic import
    source ${pkgs.versionCheckHook}/nix-support/setup-hook
    versionCheckHook
  '';

  meta = {
    description = "umo is an automatic modlist downloader for Modding-OpenMW.com";
    homepage = "https://gitlab.com/modding-openmw/tes3cmd";
    license = lib.licenses.agpl3Only;
    mainProgram = "tes3cmd";
  };
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
