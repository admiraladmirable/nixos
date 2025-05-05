{ pkgs, lib, ... }:
with lib;
{
  imports = [
    ./hyprland.nix
    ./rofi.nix
    ./swww.nix
    ./waybar.nix
  ];
}
