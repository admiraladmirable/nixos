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
}
