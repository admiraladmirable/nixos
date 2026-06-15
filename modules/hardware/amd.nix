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

      # fwupd-refresh.service runs as the unprivileged `fwupd-refresh` user with
      # no active login session. Polkit's default for the `refresh-remote` action
      # is allow_active=yes / allow_inactive=no, so the session-less service is
      # denied ("Failed to obtain auth") and nh reports the activation as failed.
      # Authorize that user explicitly so the daily metadata refresh succeeds.
      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (action.id == "org.freedesktop.fwupd.refresh-remote" &&
              subject.user == "fwupd-refresh") {
            return polkit.Result.YES;
          }
        });
      '';

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
