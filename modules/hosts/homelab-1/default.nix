{ config, ... }:
{
  configurations.nixos."homelab-1".module = {
    imports = with config.flake.modules.nixos; [
      base
      server
      k8sServer
      longhorn
      homelab1
    ];
  };
}
