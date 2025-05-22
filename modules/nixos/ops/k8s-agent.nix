{
  config,
  lib,
  pkgs,
  meta,
  ...
}:
with lib;
{
  options.k8s.agent.enable = mkEnableOption "Enable k8s";

  config = mkIf config.k8s.agent.enable {
    services.k3s = {
      enable = true;
      role = "agent";

      # Hack
      tokenFile = "/var/lib/rancher/k3s/server/token";
      extraFlags = toString ([
        "--server https://homelab-0:6443"
      ]);
      clusterInit = (meta.hostname == "homelab-0");
    };
    users.users.rmrf = {
      packages = with pkgs; [
        kubernetes-helm
        kubectl
        terraform
        cilium-cli
        hubble
        iptables
        # etcd
      ];
    };
  };
}
