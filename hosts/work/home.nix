{
  pkgs,
  lib,
  inputs,
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
    ../../modules/home-manager/vscode.nix
    ../../modules/home-manager/direnv.nix
    ../../modules/home-manager/lan-mouse.nix
  ];
}
