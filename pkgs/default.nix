# Overlay that exposes custom packages; extend this file as new packages are added.
final: prev:
let
  mkMomwTool =
    packageName: binaryName:
    prev.callPackage ./momw-tools-pack/tool.nix {
      inherit binaryName packageName;
    };
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
    postInstall =
      (old.postInstall or "")
      + ''
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
  openmw-validator = prev.callPackage ./momw-tools-pack/tool.nix {
    binaryName = "openmw-validator-linux-amd64";
    packageName = "openmw-validator";
    extraBinaryNames = [
      "openmw-validator-linux-amd64"
      "openmw_validator"
    ];
  };
  openmw-validator-linux-amd64 = final."openmw-validator";

  # portmod-gui imports PySide6 at runtime; keep it in the wrapped app closure.
  portmod = prev.portmod.overrideAttrs (old: {
    propagatedBuildInputs = (old.propagatedBuildInputs or [ ]) ++ [ prev.python3Packages.pyside6 ];
  });

  s3lightfixes = mkMomwTool "s3lightfixes" "s3lightfixes";
  tes3cmd = prev.callPackage ./momw-tools-pack/tes3cmd.nix { };
  lmstudio = prev.callPackage ./lmstudio/default.nix { };
  umo = prev.callPackage ./umo/default.nix { };
  vcv-rack-custom = prev.callPackage ./vcv-rack/default.nix { };
  falcon-sensor = prev.callPackage ./falcon-sensor/default.nix { };
  # openshot-qt 3.5.1 calls libopenshot Settings.DefaultOMPThreads(), which
  # was added in libopenshot 0.7.0. That in turn requires libopenshot-audio
  # >= 0.6.0. nixpkgs libsForQt5 still ships the 0.4.0 pair.
  libopenshot-audio = prev.libsForQt5.libopenshot-audio.overrideAttrs (old: rec {
    version = "0.6.0";
    src = prev.fetchFromGitHub {
      owner = "OpenShot";
      repo = "libopenshot-audio";
      rev = "v${version}";
      hash = "sha256-NfwjyX+9OiS4NoB4ubscNF52kF4i3GAVjb4Z/RwkaCI=";
    };
  });

  libopenshot = (prev.libsForQt5.libopenshot.override {
    libopenshot-audio = final.libopenshot-audio;
  }).overrideAttrs (old: rec {
    version = "0.7.0";
    src = prev.fetchFromGitHub {
      owner = "OpenShot";
      repo = "libopenshot";
      rev = "v${version}";
      hash = "sha256-V5eHsCqIWKe5O1xFWo847oZpY6lgjkWYmgSy5DMxH6w=";
    };
    # 0.7.0 already handles FFmpeg 8 profile constants; the nixpkgs patch would fail.
    postPatch = "";
  });

  openshot-qt = prev.callPackage ./openshot-qt/default.nix {
    inherit (prev) openshot-qt;
    libopenshot = final.libopenshot;
  };
}
