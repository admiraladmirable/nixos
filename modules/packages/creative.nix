{ ... }:
{
  # openshot-qt depends on pyqtwebengine, which pulls in qtwebengine-5.15.19.
  # Upstream Qt 5 is EOL; nixpkgs marks it insecure. Same applies to the
  # stock openshot-qt in nixpkgs — not specific to our 3.5.1 override. Scoped
  # to the `creative` bundle (rather than base) so only hosts that import it
  # carry the insecure permission.
  flake.modules.nixos.creative = {
    nixpkgs.config.permittedInsecurePackages = [ "qtwebengine-5.15.19" ];
  };

  flake.modules.homeManager.creative =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        (blender.override { cudaSupport = true; })
        gimp
        # davinci-resolve
        openshot-qt
        audacity
        xlights
      ];
    };
}
