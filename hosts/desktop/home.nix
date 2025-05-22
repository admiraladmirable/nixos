{
  pkgs,
  lib,
  inputs,
  openmw-nix,
  ...
}:
{
  home.stateVersion = "23.05";
  imports = [
    ./usr-pkgs.nix
    ../../modules/home-manager/git.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/firefox.nix
    ../../modules/home-manager/zathura.nix
    ../../modules/home-manager/direnv.nix
    ../../modules/home-manager/lan-mouse.nix
    ../../modules/home-manager/hyprland
    ../../modules/home-manager/gh.nix
    ../../modules/home-manager/openmw.nix
  ];
}
