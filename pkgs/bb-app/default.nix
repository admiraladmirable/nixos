{
  appimageTools,
  fetchurl,
  lib,
}:
let
  pname = "bb-app";
  version = "0.47.1";

  src = fetchurl {
    url = "https://github.com/get-bb/bb/releases/download/desktop-v${version}/bb-${version}-x86_64.AppImage";
    hash = "sha256-rECk/fmgZf8SfTnD+DlK7S4ceZgbnxukFt172XF10sA=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  # The desktop file and icon names are not documented; install what the
  # AppImage ships.
  extraInstallCommands = ''
    for desktop in ${appimageContents}/*.desktop; do
      install -m 444 -D "$desktop" $out/share/applications/bb-app.desktop
      substituteInPlace $out/share/applications/bb-app.desktop \
        --replace-quiet 'Exec=AppRun --no-sandbox %U' 'Exec=bb-app %U' \
        --replace-quiet 'Exec=AppRun %U' 'Exec=bb-app %U'
    done
    if [ -d ${appimageContents}/usr/share/icons ]; then
      cp -r ${appimageContents}/usr/share/icons $out/share/
    fi
  '';

  meta = {
    description = "Agentic IDE that drives Claude Code, Codex, and other provider CLIs";
    homepage = "https://github.com/get-bb/bb";
    license = lib.licenses.mit;
    mainProgram = "bb-app";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}
