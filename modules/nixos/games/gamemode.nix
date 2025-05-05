{
  config,
  lib,
  pkgs,
  openmw-nix,
  ...
}:
with lib;
{
  options.gamemode.enable = mkEnableOption "Enable gamemode";

  config = mkIf config.gamemode.enable {
    programs.gamemode = {
      enable = true;
      # settings = {
      #   gpu = {
      #     apply_gpu_optimizations = "accept-responsibility";
      #     gpu_device = 1;
      #   };
      # };
    };
  };
}
