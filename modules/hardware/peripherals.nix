{ ... }:
{
  flake.modules.nixos.peripherals =
    { pkgs, ... }:
    {
      services.udev.packages = with pkgs; [
        vial
        via
        hplip
      ];

      services.ratbagd.enable = true;
      services.udisks2.enable = true;

      services.hardware.openrgb.enable = true;
      environment.systemPackages = with pkgs; [ openrgb-with-all-plugins ];

      programs.coolercontrol.enable = true;
    };
}
