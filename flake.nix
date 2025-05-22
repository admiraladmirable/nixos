{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      # inputs.nixpkgs.follows = "nixpkgs";
    };

    lan-mouse.url = "github:feschber/lan-mouse";

    hyprland = {
      url = "github:hyprwm/Hyprland";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    rose-pine-hyprcursor = {
      url = "github:ndom91/rose-pine-hyprcursor";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.hyprlang.follows = "hyprland/hyprlang";
    };

    nix-ld = {
      url = "github:Mic92/nix-ld";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    musnix = {
      url = "github:musnix/musnix";
    };

    openmw-nix = {
      url = "git+https://codeberg.org/PopeRigby/openmw-nix.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nix-ld,
      ghostty,
      stylix,
      musnix,
      openmw-nix,
      ...
    }@inputs:
    let
      hosts = [
        "desktop"
        "homelab-0"
        "homelab-1"
        "work"
      ];
      # debug
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      nixosConfigurations = builtins.listToAttrs (
        map (hostname: {
          name = hostname;
          value = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs;
              meta = {
                hostname = hostname;
              };
            };
            modules = [
              ./hosts/${hostname}
              ./modules/nixos
              nix-ld.nixosModules.nix-ld
              stylix.nixosModules.stylix
              musnix.nixosModules.musnix
              { nixpkgs.config.allowUnfree = true; }
              home-manager.nixosModules.home-manager
              {
                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;
                home-manager.backupFileExtension = "backup";
                home-manager.users.rmrf = import ./hosts/${hostname}/home.nix;
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                  inherit nixpkgs;
                  inherit ghostty;
                  inherit openmw-nix;
                };
              }
            ];
          };
        }) hosts
      );
      # debug
      # packages.${system}.momw-tools-pack = pkgs.callPackage ./modules/pkgs/momw-tools-pack { };
    };
}
