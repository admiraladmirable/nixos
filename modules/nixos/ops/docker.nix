{ config, lib, pkgs, ... }:
with lib;
{
  options.docker.enable = mkEnableOption "Enable docker/podman";

  config = mkIf config.docker.enable {
    hardware.nvidia-container-toolkit.enable = true;

    virtualisation.docker = {
      enable = true;
      # enableNvidia = true;
    };
  };
}
