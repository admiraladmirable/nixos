{ inputs, config, ... }:
{
  flake.modules.nixos.base = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "backup";

      users.rmrf = {
        imports = [ config.flake.modules.homeManager.base ];
        home.stateVersion = "23.05";
      };
    };
  };

  # Desktop hosts additionally import the desktop HM bucket
  flake.modules.nixos.desktop = {
    home-manager.users.rmrf.imports = [
      config.flake.modules.homeManager.workstation
      config.flake.modules.homeManager.desktop
    ];
  };

  flake.modules.nixos.server = {
    home-manager.users.rmrf.imports = [ config.flake.modules.homeManager.workstation ];
  };

  flake.modules.nixos.work = {
    home-manager.users.rmrf.imports = [ config.flake.modules.homeManager.workstation ];
  };
}
