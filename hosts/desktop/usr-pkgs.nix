{ pkgs, ghostty, ... }:
{
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    ffmpeg
    libavif
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
    kdePackages.kcalc
    kdePackages.filelight
    gparted
    neofetch
    kubectl
    kubernetes-helm
    # checkov
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    xlights
    ripgrep
    nerd-fonts.droid-sans-mono
    gh
    ghostty.packages.x86_64-linux.default
    nixd
    bottles
    poppler_utils
    opentofu
    awscli2
    cilium-cli
    brave
    chromium
    libreoffice
    xorg.xeyes
    cbonsai
    blender
    kubectl
    kubernetes-helm
    cilium-cli
    iptables
    wine64Packages.wayland
    mission-center
    protonplus
  ];
}
