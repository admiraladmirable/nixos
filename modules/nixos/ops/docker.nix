{ config, lib, ... }:
with lib;
let
  cfg = config.docker;
in {
  options.docker = {
    enable = mkEnableOption "Enable docker/podman";
    enable-nvidia = mkOption {
      type = types.bool;
      default = false;
      description = "Enable nvidia support for docker";
    };
  };

  config = mkIf cfg.enable {
    hardware.nvidia-container-toolkit.enable = cfg.enable-nvidia;

    virtualisation.docker = {
      enable = true;
      enableNvidia = cfg.enable-nvidia;
    };
  };
}
