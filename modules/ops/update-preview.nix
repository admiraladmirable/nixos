{ ... }:
{
  # Hosts opt in by importing updatePreview.
  flake.modules.nixos.updatePreview =
    { config, pkgs, ... }:
    let
      hostname = config.networking.hostName;
    in
    {
      home-manager.users.rmrf =
        { config, ... }:
        let
          repository = "${config.home.homeDirectory}/.config/nixos";
          stateDirectory = "${config.xdg.stateHome}/nixos-update";
          prepare = pkgs.writeShellApplication {
            name = "nixos-update-preview";
            runtimeInputs = [
              pkgs.git
              pkgs.nh
              pkgs.nix
              pkgs.coreutils
              pkgs.libnotify
              pkgs.util-linux
            ];
            text = ''
              mkdir -p ${pkgs.lib.escapeShellArg stateDirectory}
              exec 9>${pkgs.lib.escapeShellArg (stateDirectory + "/job.lock")}
              flock -n 9 || exit 0

              notify() {
                printf '%s\n%s\n' "$1" "$2" > ${pkgs.lib.escapeShellArg (stateDirectory + "/status")}
                notify-send --app-name="NixOS updates" "$1" "$2" || true
              }

              trap 'notify "NixOS update failed" "View logs: journalctl --user -u nixos-update-preview.service"; exit 1' ERR
              cd ${pkgs.lib.escapeShellArg repository}

              # Includes a lock-file update left for review by a previous run.
              if [[ -n "$(git status --porcelain)" ]]; then
                notify "NixOS update skipped" "Your configuration has uncommitted changes. Commit or stash them before preparing another update."
                exit 0
              fi

              nh os build --update --no-nom --hostname ${pkgs.lib.escapeShellArg hostname} \
                --out-link ${pkgs.lib.escapeShellArg (stateDirectory + "/result")} \
                ${pkgs.lib.escapeShellArg repository}

              notify "NixOS update built" "Review flake.lock, then run nh os switch when ready. No changes have been activated."
            '';
          };
        in
        {
          systemd.user.services.nixos-update-preview = {
            Unit.Description = "Prepare NixOS updates without activating them";
            Service = {
              Type = "oneshot";
              ExecStart = "${prepare}/bin/nixos-update-preview";
              Nice = 10;
              IOSchedulingClass = "idle";
            };
          };
          systemd.user.timers.nixos-update-preview = {
            Unit.Description = "Prepare NixOS updates nightly";
            Timer = {
              OnCalendar = "02:00";
              RandomizedDelaySec = "45min";
              Persistent = true;
            };
            Install.WantedBy = [ "timers.target" ];
          };
        };
    };
}
