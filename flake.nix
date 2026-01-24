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
      inputs.nixpkgs.follows = "nixpkgs";
    };

    musnix = {
      url = "github:musnix/musnix";
    };

    awsvpnclient = {
      # url = "path:/home/rmrf/dev/awsvpnclient-flake";
      url = "github:admiraladmirable/awsvpnclient-flake";
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
      awsvpnclient,
      ...
    }@inputs:
    let
      hosts = [
        "desktop"
        "homelab-0"
        "homelab-1"
        "work"
      ];
      system = "x86_64-linux";
      # overlays = import ./overlays;
      # pkgsForSystem =
      #   system:
      #   import nixpkgs {
      #     overlays = [
      #       localOverlay
      #     ];
      #     inherit system;
      #   };
      overlays = {
        default = final: prev: {
          falcon-sensor = final.callPackage ./modules/pkgs/falcon-sensor/falcon.nix { };
        };
      };
      pkgs =
        system:
        import nixpkgs {
          inherit system;
          overlays = [
            overlays.default
          ];
        };
    in
    {
      # overlays = overlays;
      overlays = overlays;

      nixosModules = {
        falcon-sensor = import ./modules/pkgs/falcon-sensor;
      };

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
              awsvpnclient.nixosModules.default
              {
                nixpkgs.overlays = [ overlays.default ];
                nixpkgs.config.allowUnfree = true;
                # nixpkgs.config.permittedInsecurePackages = [ "openssl-1.1.1w" ]; # needed for awsvpnclient
              }
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
                };
              }
            ];
          };
        }) hosts
      );

      packages.${system} = {
        # inherit (pkgs) falcon-sensor;
      };
    };
}
