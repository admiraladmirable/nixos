{
  config,
  lib,
  pkgs,
  meta,
  ...
}:
with lib;
{
  options.k8s.server.enable = mkEnableOption "Enable k8s";

  config = mkIf config.k8s.server.enable {
    services.k3s = {
      enable = true;
      role = "server";

      # Hack
      tokenFile = "/var/lib/rancher/k3s/server/token";
      extraFlags = toString (
        [
          "--write-kubeconfig-mode \"0644\""
          "--disable servicelb"
          "--disable traefik"
          "--flannel-backend=none"
          "--disable-network-policy"
          "--disable-kube-proxy"
        ]
        ++ (
          if meta.hostname == "homelab-0" then
            [ ]
          else
            [
              "--server https://homelab-0:6443"
            ]
        )
      );
      clusterInit = (meta.hostname == "homelab-0");
    };
    users.users.rmrf = {
      packages = with pkgs; [
        kubernetes-helm
        kubectl
        terraform
        cilium-cli
        iptables
        # etcd
      ];
    };
  };
}
