{ pkgs }:
pkgs.stdenv.mkDerivation {
  pname = "drata-agent";
  version = "3.9.0";

  # Import the proprietary installer once; keep it out of the repository.
  src = pkgs.requireFile {
    name = "Drata-Agent-linux.deb";
    hash = "sha256-eNs+iHsUAkz1uxJ8zA84lSGlYsS6jKxYf+FaB2qiSiw=";
    message = ''
      Download Drata Agent 3.9.0 for Linux (amd64), then run:
        nix-store --add-fixed sha256 /home/rmrf/Downloads/Drata-Agent-linux.deb
    '';
  };

  nativeBuildInputs = with pkgs; [
    asar
    autoPatchelfHook
    dpkg
    makeWrapper
    wrapGAppsHook3
  ];
  buildInputs = with pkgs; [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    glib
    gsettings-desktop-schemas
    gtk3
    libdrm
    libgbm
    libGL
    libnotify
    libsecret
    libuuid
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    libxscrnsaver
    libxtst
    nspr
    nss
    pango
    stdenv.cc.cc.lib
    systemd
  ];
  runtimeDependencies = with pkgs; [
    libGL
    libsecret
    systemd
  ];

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb -x "$src" .
    runHook postUnpack
  '';

  # Tray popups lose focus while crossing other surfaces on Hyprland.
  # Keep the window open until the user toggles the tray icon or closes it.
  # Only change window behavior; leave all compliance queries untouched.
  postUnpack = ''
    asar extract "opt/Drata Agent/resources/app.asar" drata-app
    substituteInPlace drata-app/dist/main.js \
      --replace-fail 'this.window.on("blur",()=>{this.hideWindow()})' \
                     'this.window.on("blur",()=>{})'
    asar pack drata-app "opt/Drata Agent/resources/app.asar"
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib" "$out/bin"
    cp -r "opt/Drata Agent" "$out/lib/drata-agent"
    cp -r usr/share "$out/share"
    # Use Chromium's user-namespace sandbox, not a setuid store binary.
    rm "$out/lib/drata-agent/chrome-sandbox"
    makeWrapper "$out/lib/drata-agent/drata-agent" "$out/bin/drata-agent" \
      --prefix PATH : ${
        pkgs.lib.makeBinPath [
          pkgs.xdg-utils
          pkgs.coreutils
          pkgs.procps
          pkgs.util-linux
        ]
      }
    substituteInPlace "$out/share/applications/drata-agent.desktop" \
      --replace-fail 'Exec="/opt/Drata Agent/drata-agent"' "Exec=$out/bin/drata-agent"
    runHook postInstall
  '';

  meta = {
    description = "Drata device compliance tray agent";
    homepage = "https://drata.com";
    license = pkgs.lib.licenses.unfree;
    sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "drata-agent";
  };
}
