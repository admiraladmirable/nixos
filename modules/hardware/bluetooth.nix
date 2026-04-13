{ ... }:
{
  flake.modules.nixos.desktop = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;
    services.upower.enable = true;
  };
}
