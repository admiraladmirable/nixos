{ lib, ... }:
with lib;
{
  imports = [
    ./kde.nix
    ./hyprland.nix
    ./gpu-screen-recorder.nix
    ./stylix.nix
  ];
}
