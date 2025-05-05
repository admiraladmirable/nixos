{ pkgs, lib, ... }:
with lib;
{
  imports = [
    ./hyprland.nix
    ./waybar.nix
  ];
}
