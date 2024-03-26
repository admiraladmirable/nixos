{ ... }: {
  home.stateVersion = "23.05";
  imports = [
    ./git.nix
    #./zsh.nix
    ./tmux.nix
    ./kitty.nix
    ./firefox.nix
    ./usr-pkgs.nix
    ./zathura.nix
    ./hyprland.nix
    ./vscode.nix
    ./direnv.nix
  ];
}
