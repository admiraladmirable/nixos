{
  stdenv,
  lib,
  fetchurl,
  autoPatchelfHook,
  makeWrapper,
  e2fsprogs,
  lz4,
  zlib,
  zstd,
  xxhash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "docker-sbx";
  version = "0.28.3";

  src = fetchurl {
    url = "https://github.com/docker/sbx-releases/releases/download/v${finalAttrs.version}/DockerSandboxes-linux.tar.gz";
    hash = "sha256-vIAA2Z0NjSXcDTk71d/CHWf6O/COCGunCylN6RVqWDE=";
  };

  sourceRoot = "docker-sbx";

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc.lib
    lz4
    zlib
    zstd
    xxhash
  ];

  dontStrip = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 sbx -t $out/bin
    install -Dm755 containerd-shim-nerdbox-v1 -t $out/libexec
    install -Dm755 mkfs.erofs -t $out/libexec
    install -Dm755 libkrun.so -t $out/libexec/lib

    for f in nerdbox-kernel-* nerdbox-initrd-*; do
      [ -f "$f" ] && install -Dm644 "$f" "$out/libexec/$(basename "$f")"
    done

    install -Dm644 LICENSE -t $out/share/doc/${finalAttrs.pname}
    install -Dm644 THIRD-PARTY-NOTICES -t $out/share/doc/${finalAttrs.pname}
    install -Dm644 apparmor-profile $out/share/${finalAttrs.pname}/apparmor-profile

    runHook postInstall
  '';

  # The shim dlopen()s libkrun.so by bare name. Point its runpath at the
  # bundled copy under libexec/lib (matches upstream install.sh layout).
  appendRunpaths = [ "${placeholder "out"}/libexec/lib" ];

  postFixup = ''
    wrapProgram $out/bin/sbx \
      --prefix PATH : ${lib.makeBinPath [ e2fsprogs ]}
  '';

  meta = {
    description = "Docker Sandboxes — safe environments for AI agents";
    longDescription = ''
      docker-sbx provides sandboxes with controlled access to the filesystem,
      network, and tools so agents can work autonomously without putting the
      host or its data at risk. Backed by libkrun microVMs and the nerdbox
      containerd shim.

      Requires KVM access — add the user to the kvm group:
        sudo usermod -aG kvm $USER

      On AppArmor-restrictive systems (Ubuntu 23.10+) install the bundled
      profile at $out/share/docker-sbx/apparmor-profile system-wide so the
      nerdbox shim is allowed to create user namespaces.
    '';
    homepage = "https://github.com/docker/sbx-releases";
    license = lib.licenses.asl20;
    mainProgram = "sbx";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})
