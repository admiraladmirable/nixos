{ pkgs, lib, config, ... }:
let
  cfg = config.services.falcon-sensor;
  falcon = cfg.package;
  startPreScript = pkgs.writeScript "init-falcon" ''
    #! ${pkgs.bash}/bin/sh
    /run/current-system/sw/bin/mkdir -p /opt/CrowdStrike
    ln -sf ${falcon}/opt/CrowdStrike/* /opt/CrowdStrike
    ${falcon}/bin/fs-bash -c "${falcon}/opt/CrowdStrike/falconctl -g --cid"
  '';
in
{
  options.services.falcon-sensor = {
    enable = lib.mkEnableOption "CrowdStrike Falcon Sensor service";
    package = lib.mkPackageOption pkgs "falcon-sensor" { };
  };

  config = lib.mkIf cfg.enable {
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
