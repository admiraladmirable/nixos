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

    lan-mouse.url = "github:feschber/lan-mouse";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flake-parts = {
    #   url = "github:hercules-ci/flake-parts";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs =
    inputs@{ nixpkgs, home-manager, nixvim, ... }:
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/desktop
            ./modules/nixos
            { nixpkgs.config.allowUnfree = true; }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.rmrf = import ./modules/home-manager/default.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit nixpkgs;
              };
            }
          ];
        };
        work = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/work
            ./modules/nixos
            { nixpkgs.config.allowUnfree = true; }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.rmrf = import ./modules/home-manager/default.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit nixpkgs;
              };
            }
          ];
        };
        homelab = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {
            inherit inputs;
          };
          modules = [
            ./hosts/homelab
            ./modules/nixos
            { nixpkgs.config.allowUnfree = true; }
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.rmrf = import ./modules/home-manager/default.nix;
              home-manager.extraSpecialArgs = {
                inherit inputs;
                inherit nixpkgs;
              };
            }
          ];
        };
      };
    };
}
