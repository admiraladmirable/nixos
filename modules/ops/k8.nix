
{ config, lib, pkgs, ...}:
with lib;
{
  options.k8.enable = mkEnableOption "Enable k8";

  config = mkIf config.k8.enable {
    services.k3s.enable = true;
    services.k3s.role = "server";
    users.users.rick-topl = {
      packages = with pkgs; [
        kubernetes-helm
        kubectl
        k3s
        terraform
      ];
    };
  };
}
