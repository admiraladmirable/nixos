{ config, ... }:
{
  configurations.nixos.desktop.module = {
    imports = with config.flake.modules.nixos; [
      base
      hyprland
      desktopMachine
      pipewire
      steam
      nvidia
      peripherals
      printing
      desktopNetworking
      polkitAgent
      yubikeyWorkstation
      desktop
    ];
  };
}
