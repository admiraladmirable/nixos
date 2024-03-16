
{ config, lib, pkgs, ...}:
with lib;
{
  options.k8.enable = mkEnableOption "Enable k8";

  config = mkIf config.k8.enable {
    users.users.rick-topl = {
      packages = with pkgs; [
        kubernetes-helm
        kubectl
        kind
        terraform
        awscli2
      ];
    };
  };
}
