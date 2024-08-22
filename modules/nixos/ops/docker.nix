{ config, lib, pkgs, ... }:
with lib;
{
  options.docker.enable = mkEnableOption "Enable docker/podman";

  config = mkIf config.docker.enable {
    # virtualisation = {
    #   podman = {
    #       enable = true;
    #       # Create a `docker` alias for podman, to use it as a drop-in replacement
    #       dockerCompat = true;

    #       # Required for containers under podman-compose to be able to talk to each other.
    #       defaultNetwork.settings.dns_enabled = true;
    #     };
    # };
    hardware.nvidia-container-toolkit.enable = true;

    virtualisation.docker = {
      enable = true;
      package = pkgs.docker_25;

      extraOptions = "--default-runtime=nvidia";
    };
  };
}
