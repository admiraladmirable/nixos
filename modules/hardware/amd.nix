{ ... }:
{
  flake.modules.nixos.amd =
    { ... }:
    {
      hardware = {
        enableRedistributableFirmware = true;
        graphics.enable = true;
      };

      services.fwupd.enable = true;

      environment.variables = {
        LIBVA_DRIVER_NAME = "radeonsi";
      };

      home-manager.sharedModules = [
        {
          home.sessionVariables = {
            LIBVA_DRIVER_NAME = "radeonsi";
          };
        }
      ];
    };
}
