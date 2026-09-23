{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, lib, ... }:
    let
      treeSitterGrammars = pkgs.linkFarm "tree-sitter-grammars-dir" (
        lib.mapAttrsToList
          (name: drv: {
            inherit name;
            path =
              if name == "tree-sitter-cuda" && drv.src.rev == "v0.21.2" then
                # The v0.21.2 archive no longer matches the hash in nixpkgs.
                # Pin its commit until the nixpkgs source definition is updated.
                pkgs.fetchFromGitHub {
                  inherit (drv.src) owner repo;
                  rev = "d58080a327756e4d1d16ec329ba7cb2048f6c6cd";
                  hash = "sha256-s2qrZx5fEu/I6xE2paX/Nlmgvo6T27qqvy1cI8iznAA=";
                }
              else
                drv.src;
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
        libxcrypt
        p7zip-rar
        piper
        egl-wayland
        xeyes
        udiskie
        tree-sitter
        jujutsu
        jjui
        lm_sensors
        pi-coding-agent
        kind
        # ventoy
      ];

      xdg.configFile."tree-sitter/config.json".text = builtins.toJSON {
        parser-directories = [ "${treeSitterGrammars}" ];
      };
    };
}
