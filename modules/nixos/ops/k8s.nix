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
    services.k3s.enable = true;
    services.k3s.role = "server";
    users.users.rick-desktop = {
      packages = with pkgs; [
        kubernetes-helm
        kubectl
        k3s
        terraform
      ];
    };
  };
}
