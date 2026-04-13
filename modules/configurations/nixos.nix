{ inputs, lib, config, ... }:
{
  options.configurations.nixos = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.module = lib.mkOption {
          type = lib.types.deferredModule;
        };
      }
    );
  };

  config.flake.nixosConfigurations = lib.mapAttrs (
    name:
    { module }:
    inputs.nixpkgs.lib.nixosSystem {
      modules = [ module ];
    }
  ) config.configurations.nixos;
}
