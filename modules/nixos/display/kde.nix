{ lib, config, ... }:
with lib;
{
  imports = [ ./xorg.nix ];
  options.kde.enable = mkEnableOption "Enable KDE 6 w/ Xorg";

  config = mkIf config.kde.enable {
    xorg.enable = mkDefault true;

    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;
    services.desktopManager.plasma6.enable = true;
  };
}
