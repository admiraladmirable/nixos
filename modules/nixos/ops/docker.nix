{ config, lib, pkgs, ... }:
with lib;
{
  options.docker.enable = mkEnableOption "Enable docker/podman";
  options.docker.nvidia.enable = mkEnableOption "Enable Nvidia container toolkit";

  config = mkIf config.docker.enable {
    hardware.nvidia-container-toolkit.enable = config.docker.nvidia.enable;

    virtualisation.docker = {
      enable = true;
    };
  };
}
