{
  description = "NixOS configuration";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:nixos/nixpkgs/staging-next"; # temp fix for CVE
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    lan-mouse.url = "github:feschber/lan-mouse";
  };

  outputs = inputs@{ nixpkgs, nixpkgs-unstable, home-manager, ... }: {
    nixosConfigurations = {
      work = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/work/work.nix
          ./modules/nixos
          { nixpkgs.config.allowUnfree = true; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.rick-topl =
              import ./modules/home-manager/default.nix;
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
