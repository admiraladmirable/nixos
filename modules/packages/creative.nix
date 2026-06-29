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
    let
      # GIMP 3.2.4 ships unwrapped in nixpkgs (raw ELF, no wrapGAppsHook), so it
      # has no GSettings schema path of its own and falls back to ambient
      # XDG_DATA_DIRS, which only carries GTK4's schemas. GIMP 3.2 is a GTK3
      # app and aborts when opening a file dialog because it can't find
      # org.gtk.Settings.FileChooser (provided by gtk3, not gtk4). Wrap it so
      # GTK3's compiled schemas are on GSETTINGS_SCHEMA_DIR.
      gimp' = pkgs.symlinkJoin {
        name = "gimp-wrapped-${pkgs.gimp.version}";
        paths = [ pkgs.gimp ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          schemadir=$(echo ${pkgs.gtk3}/share/gsettings-schemas/*/glib-2.0/schemas)
          for b in gimp gimp-3 gimp-3.2 gimp-console gimp-console-3 gimp-console-3.2; do
            if [ -e "$out/bin/$b" ]; then
              wrapProgram "$out/bin/$b" \
                --prefix GSETTINGS_SCHEMA_DIR : "$schemadir"
            fi
          done
        '';
      };
    in
    {
      home.packages = with pkgs; [
        (blender.override { cudaSupport = true; })
        gimp'
        # davinci-resolve
        openshot-qt
        audacity
        xlights
        godot
      ];
    };
}
