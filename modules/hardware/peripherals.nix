{ ... }:
{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      hardware.ledger.enable = true;

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
      programs.gpu-screen-recorder.enable = true;
    };
}
