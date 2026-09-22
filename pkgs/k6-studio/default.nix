{ pkgs }:
let
  version = "1.13.1";
  release =
    {
      x86_64-linux = {
        arch = "amd64";
        hash = "sha256-xIrQx8obbSY4QJRcl4tzL2j1ibgUEyhOk1olY7DYG1E=";
      };
      aarch64-linux = {
        arch = "arm64";
        hash = "sha256-MzmA4px0VlMDIhIvC4uO9YeW2uvbtaEnXUycJ0ALWMk=";
      };
    }
    .${pkgs.stdenv.hostPlatform.system};
in
pkgs.stdenv.mkDerivation {
  pname = "k6-studio";
  inherit version;

  src = pkgs.fetchurl {
    url = "https://github.com/grafana/k6-studio/releases/download/v${version}/k6-studio_${version}_${release.arch}.deb";
    inherit (release) hash;
  };

  nativeBuildInputs = with pkgs; [
    autoPatchelfHook
    dpkg
  ];

  buildInputs = with pkgs; [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    glib
    gtk3
    libdrm
    libgbm
    libGL
    libx11
    libxcb
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxkbcommon
    libxrandr
    nspr
    nss
    pango
    systemd
  ];

  runtimeDependencies = [ pkgs.systemd ];

  preFixup = ''
    patchelf --add-needed libGL.so.1 \
      --add-needed libEGL.so.1 \
      --add-rpath ${pkgs.lib.makeLibraryPath [ pkgs.libGL ]} \
      $out/lib/k6-studio/k6-studio
  '';

  unpackPhase = ''
    runHook preUnpack
    dpkg-deb --fsys-tarfile $src | tar --no-same-owner --no-same-permissions -xf -
    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r usr/* $out/
    rm $out/lib/k6-studio/chrome-sandbox
    runHook postInstall
  '';

  meta = {
    description = "Desktop application for creating and debugging k6 performance tests";
    homepage = "https://github.com/grafana/k6-studio";
    changelog = "https://github.com/grafana/k6-studio/releases/tag/v${version}";
    license = pkgs.lib.licenses.agpl3Only;
    mainProgram = "k6-studio";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
  };
}
