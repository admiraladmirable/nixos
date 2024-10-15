{ pkgs, ... }:
{
  home.packages = with pkgs; [
    ffmpeg
    mpv
    btop
    irssi
    any-nix-shell
    figlet
    ranger
    docker-compose
    newsflash
    alejandra
    nixfmt-rfc-style
    terraform
    terragrunt
    obs-studio
    kcalc

    gparted
    neofetch
    # checkov
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
  ];
}
