{ ... }:
{
  flake.modules.nixos.base = {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;
    services.upower.enable = true;
  };
}
