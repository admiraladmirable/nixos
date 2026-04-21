{ inputs, config, ... }:
{
  flake.overlays.default = import ../../pkgs/default.nix;

  flake.modules.nixos.base = {
    nixpkgs.overlays = [
      config.flake.overlays.default
      inputs.claude-code-nix.overlays.default
    ];
    nixpkgs.config.allowUnfree = true;
    # openshot-qt depends on pyqtwebengine, which pulls in qtwebengine-5.15.19.
    # Upstream Qt 5 is EOL; nixpkgs marks it insecure. Same applies to the
    # stock openshot-qt in nixpkgs — not specific to our 3.5.1 override.
    nixpkgs.config.permittedInsecurePackages = [ "qtwebengine-5.15.19" ];
  };
}
