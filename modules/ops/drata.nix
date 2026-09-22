{ ... }:
{
  flake.modules.nixos.drata = { pkgs, ... }: {
    home-manager.users.rmrf = {
      home.packages = [ pkgs.drata-agent ];
      xdg.mimeApps.defaultApplications."x-scheme-handler/auth-drata-agent" = [
        "drata-agent.desktop"
      ];
      systemd.user.services.drata-agent = {
        Unit = {
          Description = "Drata device compliance agent";
          After = [ "graphical-session.target" ];
          PartOf = [ "graphical-session.target" ];
        };
        Service = {
          # Electron may miss tray registration when launched before the tray host.
          ExecStartPre = pkgs.writeShellScript "wait-for-drata-tray" ''
            for ((attempt = 0; attempt < 30; attempt++)); do
              if [[ "$(${pkgs.systemd}/bin/busctl --user --timeout=1 get-property \
                org.kde.StatusNotifierWatcher /StatusNotifierWatcher \
                org.kde.StatusNotifierWatcher IsStatusNotifierHostRegistered 2>/dev/null)" == "b true" ]]; then
                exit 0
              fi
              ${pkgs.coreutils}/bin/sleep 1
            done
            echo "Waiting for a StatusNotifier tray host before starting Drata" >&2
            exit 1
          '';
          ExecStart = "${pkgs.drata-agent}/bin/drata-agent";
          Restart = "on-failure";
          RestartSec = 10;
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}
