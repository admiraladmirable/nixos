{ inputs, ... }:
{
  flake.modules.nixos.falconSensor =
    { pkgs, config, ... }:
    let
      falcon = pkgs.falcon-sensor;
      startPreScript = pkgs.writeScript "init-falcon" ''
        #! ${pkgs.bash}/bin/sh
        /run/current-system/sw/bin/mkdir -p /opt/CrowdStrike
        ln -sf ${falcon}/opt/CrowdStrike/* /opt/CrowdStrike
        read -r cid < ${config.sops.secrets.falcon-cid.path}
        ${falcon}/bin/fs-bash -c "${falcon}/opt/CrowdStrike/falconctl -s --cid=$cid -f"
        ${falcon}/bin/fs-bash -c "${falcon}/opt/CrowdStrike/falconctl -g --cid"
      '';
    in
    {
      imports = [ inputs.sops-nix.nixosModules.sops ];

      # SSH is disabled on this host, so point sops at a dedicated host age key
      # (generated once with `age-keygen -o /var/lib/sops-nix/key.txt`).
      sops.age.keyFile = "/var/lib/sops-nix/key.txt";
      sops.secrets.falcon-cid.sopsFile = ./secrets/falcon.yaml;

      systemd.services.falcon-sensor = {
        description = "CrowdStrike Falcon Sensor";
        unitConfig.DefaultDependencies = false;
        after = [ "local-fs.target" ];
        conflicts = [ "shutdown.target" ];
        before = [
          "sysinit.target"
          "shutdown.target"
        ];
        serviceConfig = {
          ExecStartPre = "${startPreScript}";
          ExecStart = "${falcon}/bin/fs-bash -c \"${falcon}/opt/CrowdStrike/falcond\"";
          Type = "forking";
          PIDFile = "/run/falcond.pid";
          Restart = "no";
          TimeoutStopSec = "60s";
          KillMode = "process";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
}
