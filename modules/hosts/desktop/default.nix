{ config, ... }:
{
  configurations.nixos.desktop.module = {
    imports = with config.flake.modules.nixos; [
      base
      hyprland
      desktopMachine
      pipewire
      steam
      curseforge
      nvidia
      peripherals
      printing
      desktopNetworking
      polkitAgent
      yubikeyWorkstation
      creative
      web3
      desktop
    ];
  };
}
