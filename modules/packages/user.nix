{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, lib, ... }:
    let
      treeSitterGrammars = pkgs.linkFarm "tree-sitter-grammars-dir" (
        lib.mapAttrsToList
          (name: drv: {
            inherit name;
            path = drv.src;
          })
          (
            lib.filterAttrs (
              n: v: lib.hasPrefix "tree-sitter-" n && lib.isDerivation v && v ? src
            ) pkgs.tree-sitter-grammars
          )
      );
    in
    {
      home.packages = with pkgs; [
        btop
        mission-center
        irssi
        newsflash
        figlet
        cbonsai
        fastfetch
        any-nix-shell
        alejandra
        nixfmt
        nixd
        kdePackages.kcalc
        kdePackages.okular
        blender
        # openshot-qt
        # davinci-resolve
        xlights
        libxcrypt
        p7zip-rar
        piper
        bolt-launcher
        egl-wayland
        xeyes
        udiskie
        tree-sitter
        foundry
        jujutsu
        jjui
      ];

      xdg.configFile."tree-sitter/config.json".text = builtins.toJSON {
        parser-directories = [ "${treeSitterGrammars}" ];
      };
    };
}
