{ config, ... }:
{
  configurations.nixos.work.module = {
    imports = with config.flake.modules.nixos; [
      base
      hyprland
      pipewire
      framework16
      framework16AmdAi300
      amd
      polkitAgent
      yubikeyWorkstation
      work
      awsclientvpn
      falconSensor
    ];
  };
}
