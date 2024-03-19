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

    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs@{ nixpkgs, home-manager, nixpkgs-unstable, ... }: {
    nixosConfigurations = {
      work = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/work/work.nix
          ./modules
          { nixpkgs.config.allowUnfree = true; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.rick-topl = import ./home-manager/default.nix;
            home-manager.extraSpecialArgs = { inherit inputs; inherit nixpkgs; };
          }
        ];
      };
    };
  };
}
