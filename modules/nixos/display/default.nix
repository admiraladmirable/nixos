{ lib, ... }:
with lib;
{
  imports = [
    ./kde.nix
    # ./hyprland.nix
    # ./xrdp.nix
  ];
}
