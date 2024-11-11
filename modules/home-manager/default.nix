{ ... }:
{
  home.stateVersion = "23.05";
  imports = [
    ./git.nix
    ./tmux.nix
    ./kitty.nix
    ./firefox.nix
    ./usr-pkgs.nix
    ./zathura.nix
    ./vscode.nix
    ./direnv.nix
    ./lan-mouse.nix
    ./nvim.nix
  ];
}
