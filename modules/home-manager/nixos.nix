{ inputs, config, ... }:
{
  flake.modules.nixos.base = {
    imports = [ inputs.home-manager.nixosModules.home-manager ];

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      backupFileExtension = "hm-backup";

      users.rmrf = {
        imports = [ config.flake.modules.homeManager.base ];
        home.stateVersion = "23.05";
      };
    };
  };

}
