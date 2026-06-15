# Overlay that exposes custom packages; extend this file as new packages are added.
final: prev:
let
  mkMomwTool =
    packageName: binaryName:
    prev.callPackage ./momw-tools-pack/tool.nix {
      inherit binaryName packageName;
    };

  # wiresharkSrc = version: prev.fetchFromGitLab {
  #   owner = "wireshark";
  #   repo = "wireshark";
  #   tag = "v${version}";
  #   hash = "sha256-Zvrwxjp4LK2J3QnxmPxKKrU01YHQvPyp54UWzeGNCjA=";
  # };
in
{
  delta-plugin = prev.callPackage ./momw-tools-pack/tool.nix {
    binaryName = "delta_plugin";
    packageName = "delta-plugin";
    extraBinaryNames = [ "delta_plugin" ];
  };
  delta_plugin = final."delta-plugin";
  groundcoverify = mkMomwTool "groundcoverify" "groundcoverify";

  # Upstream installs a pkg-config file named cava.pc but some consumers look for libcava.pc.
  # Provide an alias so pkg-config lookups succeed without patching every consumer.
  libcava = prev.libcava.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      ln -sf "$out/lib/pkgconfig/cava.pc" "$out/lib/pkgconfig/libcava.pc"
    '';
  });

  momw-configurator = prev.callPackage ./momw-tools-pack/tool.nix {
    binaryName = "momw-configurator-linux-amd64";
    packageName = "momw-configurator";
    extraBinaryNames = [
      "momw-configurator-linux-amd64"
      "momw_configurator"
    ];
  };
  momw-configurator-linux-amd64 = final."momw-configurator";
  momw-tools-pack = prev.callPackage ./momw-tools-pack/default.nix { };
  nethack = prev.callPackage ./nethack/default.nix { };
  nethack-qt = final.nethack.override { qtMode = true; };
  nethack-x11 = final.nethack.override { x11Mode = true; };
  openmw-validator = prev.callPackage ./momw-tools-pack/tool.nix {
    binaryName = "openmw-validator-linux-amd64";
    packageName = "openmw-validator";
    extraBinaryNames = [
      "openmw-validator-linux-amd64"
      "openmw_validator"
    ];
  };
  openmw-validator-linux-amd64 = final."openmw-validator";

  openldap = prev.openldap.overrideAttrs (old: {
    # test017-syncreplication-refresh is intermittently failing for i686 in nixpkgs
    # and breaks consumers like bottles via the multilib Wine/FHS chain.
    doCheck = if prev.stdenv.hostPlatform.isi686 then false else (old.doCheck or true);
  });

  # portmod-gui imports PySide6 at runtime; keep it in the wrapped app closure.
  portmod = prev.portmod.overrideAttrs (old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ prev.python3Packages.pyside6 ];
  });

  s3lightfixes = mkMomwTool "s3lightfixes" "s3lightfixes";
  tes3cmd = prev.callPackage ./momw-tools-pack/tes3cmd.nix { };

  # nixos-unstable currently has a stale source hash for Wireshark 4.6.5.
  # wireshark = prev.wireshark.overrideAttrs (old: {
  #   src = if old.version == "4.6.5" then wiresharkSrc old.version else old.src;
  # });
  # wireshark-cli = prev.wireshark-cli.overrideAttrs (old: {
  #   src = if old.version == "4.6.5" then wiresharkSrc old.version else old.src;
  # });

  # Helm 4 is not in nixpkgs yet; override kubernetes-helm with a v4 build.
  # kubernetes-helm = prev.callPackage ./kubernetes-helm/default.nix { };

  lmstudio = prev.callPackage ./lmstudio/default.nix { };
  umo = prev.callPackage ./umo/default.nix { };
  vcv-rack-custom = prev.callPackage ./vcv-rack/default.nix { };
  falcon-sensor = prev.callPackage ./falcon-sensor/default.nix { };
  docker-sbx = prev.callPackage ./docker-sbx/default.nix { };
  # openshot-qt (3.5.1), libopenshot (0.7.0) and libopenshot-audio (0.6.0) are
  # now provided directly by nixpkgs at top level (previously under libsForQt5),
  # so the custom overrides that built those versions are no longer needed.
}
