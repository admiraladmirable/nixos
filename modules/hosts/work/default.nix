{ config, ... }:
{
  configurations.nixos.work.module = {
    imports = with config.flake.modules.nixos; [
      base
      work
      plasma
    ];
  };
}
