{ lib, config, ...}:
with lib; {
  imports = [
    ./xorg.nix
  ]; 
  options.kde.enable = mkEnableOption "Enable KDE w/ Xorg";

  config = mkIf config.kde.enable {
    xorg.enable = mkDefault true;

    services.xserver.displayManager.sddm.enable = true;
    services.xserver.desktopManager.plasma5.enable = true;

    # Also enable xrdp for plasma x11
    services.xrdp.enable = true;
    services.xrdp.defaultWindowManager = "startplasma-x11";
    services.xrdp.openFirewall = true;
  };
}
