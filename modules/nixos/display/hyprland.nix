{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
with lib;
{
  options.hyprland.enable = mkEnableOption "Enable Hyprland";

  config = mkIf config.hyprland.enable {
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
      # package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.default;
    };
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "catppuccin";
    };
    security.pam.services.hyprlock = { };
  };
}
