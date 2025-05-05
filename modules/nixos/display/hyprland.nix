{ lib, pkgs, inputs, config, ... }:
with lib;
{
  options.hyprland.enable = mkEnableOption "Enable Hyprland";

  config = mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
    security.pam.services.hyprlock = {};
  };
}
