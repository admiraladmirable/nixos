{ ... }:
{
  flake.modules.nixos.k8sServer =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      assertions = [
        {
          assertion = config.networking.hostName == "homelab-1";
          message = "k8sServer is currently only configured for homelab-1.";
        }
      ];

      services.k3s = {
        enable = true;
        role = "server";
        clusterInit = true;
        extraFlags = toString [
          "--write-kubeconfig-mode \"0644\""
          "--disable servicelb"
          "--disable traefik"
          "--disable-network-policy"
        ];
      };

      users.users.rmrf.packages = with pkgs; [
        kubernetes-helm
        kubectl
        terraform
        cilium-cli
        iptables
      ];
    };
}
