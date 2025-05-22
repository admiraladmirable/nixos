{
  pkgs,
  ghostty,
  openmw-nix,
  inputs,
  ...
}:
let
  # umo = pkgs.callPackage ../../modules/pkgs/umo {
  #   openmw-nix = openmw-nix;
  # };
  # momw-tools-pack = pkgs.callPackage ./modules/pkgs/momw-tools-pack { };
in
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
    fastfetch
    kubectl
    kubernetes-helm
    # checkov
    (google-cloud-sdk.withExtraComponents [ google-cloud-sdk.components.gke-gcloud-auth-plugin ])
    xlights
    ripgrep
    nerd-fonts.droid-sans-mono
    ghostty.packages.x86_64-linux.default
    nixd
    bottles
    poppler_utils
    opentofu
    awscli2
    cilium-cli
    hubble
    brave
    chromium
    libreoffice
    xorg.xeyes
    cbonsai
    blender
    kubectl
    kubernetes-helm
    iptables
    wine64Packages.wayland
    mission-center
    protonplus
    libxcrypt
    p7zip-rar
    # inputs.self.packages.x86_64-linux.momw-tools-pack
    # (pkgs.writeShellScriptBin "tes3cmd" ''
    #   exec ${import ./../../modules/pkgs/tes3cmd { inherit pkgs; }}/bin/tes3cmd
    # '')
  ];
}
