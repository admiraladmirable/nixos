{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.k8s.enable = mkEnableOption "Enable k8s";

  config = mkIf config.k8s.enable {
    services.k3s = {
      enable = true;
      role = "server";
        extraFlags = toString ([
        "--write-kubeconfig-mode \"0644\""
        "--cluster-init"
        "--disable=servicelb"
        "--disable=traefik"
        "--disable=local-storage"
        "--kube-proxy-arg=ipvs-strict-arp=true"
      ]);
    };
    users.users.rmrf = {
      packages = with pkgs; [
        kubernetes-helm
        kubectl
        terraform
      ];
    };
  };
}
