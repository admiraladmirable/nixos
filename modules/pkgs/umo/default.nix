{
  python3Packages,
  fetchFromGitLab,
  lib,
  pkgs,
  openmw-nix,
}:
python3Packages.buildPythonApplication rec {
  pname = "umo";
  version = "0.9.5";

  src = fetchFromGitLab {
    owner = "modding-openmw";
    repo = "umo";
    rev = version;
    sha256 = "sha256-DEq3aZmoLPW6dZ44yzgfM/awFWIbW2ajKWthTKhDz+E=";
  };

  pyproject = true;

  build-system = with python3Packages; [
    setuptools
  ];
  dependencies = with python3Packages; [
    coloredlogs
    desktop-notifier
    openmw-nix.packages.x86_64-linux.curldl
    pkgs.desktop-file-utils
    pycurl
    pydantic
    pycryptodomex
    platformdirs
    rarfile
    pwinput
    websockets
    certifi
    beautifulsoup4
    typer
    click
    toml
  ];

  pythonRelaxDeps = true;

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
    homepage = "https://gitlab.com/modding-openmw/umo";
    license = lib.licenses.agpl3Only;
    mainProgram = "umo";
  };
}
