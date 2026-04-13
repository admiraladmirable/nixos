{
  inputs,
  lib,
  config,
  ...
}:
{
  config.flake.modules.homeManager.base = {
    options.desktop.shell = lib.mkOption {
      type = lib.types.enum [
        "caelestia"
        "noctalia"
      ];
      default = "caelestia";
      description = "Desktop shell to run for the desktop host.";
    };
  };

  config.flake.modules.homeManager.desktop =
    { config, lib, ... }:
    {
      imports = [ inputs.caelestia-shell.homeManagerModules.default ];

      config = lib.mkIf (config.desktop.shell == "caelestia") {
        programs.caelestia = {
          enable = true;
          systemd = {
            enable = true;
            target = "graphical-session.target";
            environment = [ ];
          };
          settings = {
            bar = {
              status.showBattery = false;
              entries = [
                {
                  id = "logo";
                  enabled = true;
                }
                {
                  id = "workspaces";
                  enabled = true;
                }
                {
                  id = "spacer";
                  enabled = true;
                }
                {
                  id = "activeWindow";
                  enabled = true;
                }
                {
                  id = "spacer";
                  enabled = true;
                }
                {
                  id = "tray";
                  enabled = true;
                }
                {
                  id = "clock";
                  enabled = true;
                }
                {
                  id = "statusIcons";
                  enabled = true;
                }
                {
                  id = "power";
                  enabled = true;
                }
              ];
            };
            services.useFahrenheit = false;
            general.idle.inhibitWhenAudio = true;
            utilities.toasts = {
              audioInputChanged = true;
              audioOutputChanged = true;
              capsLockChanged = true;
              chargingChanged = true;
              configLoaded = true;
              dndChanged = true;
              gameModeChanged = true;
              kbLayoutChanged = true;
              nowPlaying = true;
              numLockChanged = true;
              vpnChanged = true;
            };
            transparency = {
              enabled = true;
              base = "0.6";
              layers = "0.2";
            };
            paths.wallpaperDir = "~/Pictures";
          };
          cli = {
            enable = true;
            settings.theme.enableGtk = false;
          };
        };
      };
    };
}
