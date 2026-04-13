{ config, ... }:
{
  configurations.nixos.desktop.module = {
    imports = with config.flake.modules.nixos; [
      base
      desktop
    ];
  };
}
