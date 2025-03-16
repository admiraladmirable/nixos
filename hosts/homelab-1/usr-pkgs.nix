{ pkgs, ghostty, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    ffmpeg
    mpv
    btop
    irssi
    any-nix-shell
    figlet
    ranger
    alejandra
    nixfmt-rfc-style
    neofetch
    kubectl
    kubernetes-helm
    # checkov
    ripgrep
    nerd-fonts.droid-sans-mono
    gh
    ghostty.packages.x86_64-linux.default
  ];
}
