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
    docker-compose
    newsflash
    alejandra
    nixfmt-rfc-style
    terraform
    terragrunt
    obs-studio
    kcalc
    kdePackages.filelight
    gparted
    neofetch
    kubectl
    kubernetes-helm
    # checkov
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    xlights
    vamp-plugin-sdk
    ripgrep
    nerd-fonts.droid-sans-mono
    gh
    ghostty.packages.x86_64-linux.default
  ];
}
