{ config, ... }:
{
  configurations.nixos."homelab-1".module = {
    imports = with config.flake.modules.nixos; [
      base
      k8sServer
      longhorn
      homelab1
    ];
  };
}
