{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../../modules/nixos
    ./hardware-configuration.nix
  ];

  # Enabled Modules
  docker.enable = true;
  k8s.agent.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = "experimental-features = nix-command flakes";
  };

  # Longhorn
  systemd.tmpfiles.rules = [
    "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
  ];

  services.openiscsi = {
    enable = true;
    name = "iqn.2020-08.org.linux-iscsi.initiatorhost:homelab-1";
  };

  # Bootloader
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest; # Use latest to get HDR fixes in
  };

  # Networking
  networking = {
    hostName = "homelab-1";
    networkmanager.enable = true;
  };

  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable sound with pipewire.
  security.rtkit.enable = true;

  users.users.rmrf = {
    isNormalUser = true;
    description = "rm-rf";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "dialout"
    ];

    hashedPassword = "$6$dAbP8R68N39TelAh$8TagDN12cSuGOrCvz9pCvKBwJzaJochIj1HE70MbDcPXeTyrfHXfUdy3Mo7E4ZtCvHWjJyFyr7j6crQBUZn.h/";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWrrtZwPBfXwYZ50IaXjpakushKItfjToNNIOFLigP9 rmrf@desktop"
    ];
  };

  # Enable OpenGL/Graphics
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    enableRedistributableFirmware = true;
    pulseaudio.enable = false;
  };

  services = {
    xserver = {
      xkb.layout = "us";
      xkb.variant = "";
    };
    openssh.enable = true;
  };

  fonts.packages = with pkgs; [ source-code-pro ];

  environment.variables = {
    FLAKE = "/home/rmrf/.config/nixos/";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    git
    wget
    bc
    autoconf
    automake
    tmux
    pciutils
    usbutils
    unzip
    fzf
    libtool
    gnumake
    cmake
    gcc
    gdb
    podman
    podman-compose
    libjpeg
    feh
    lsof
    htop
    wireshark
    nettools
    ripgrep
    fd
    jq
    tree
    lolcat
    pulseaudio
    file
    traceroute
    poppler_utils
    nmap
    bat
    xclip
    nil
    nh
    yt-dlp
    devenv
    # (import ../../packages/kenku-fm.nix)
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
      trusted-users = [ "rmrf" ];
    };

    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
    };
  };

  boot.kernel.sysctl = {
    "net.ipv4.ipv4_forward" = true;
  };

  # Open ports in the firewall.
  networking = {
    nat = {
      enable = false;
    };
    hosts = {
      "10.0.0.19" = [ "homelab-0" ];
      "10.0.0.21" = [ "desktop" ];
      "10.0.0.26" = [ "homelab-1" ];
    };

    firewall = {
      enable = false;
      checkReversePath = false;
      allowedTCPPorts = [
        22 # ssh
        53 # DNS
        6443 # k3s api
        2379 # k3s HA etcd
        2340 # k3s HA etcd
        80 # http
        443 # https
        4240 # cilium
        4244 # hubble server
        4245 # hubble relay
        4250 # mtls
        4251 # # spire
        6060
        6061
        6062
        9878
        9879
        9890
        9891
        9962
        9963
        9964
        10250 # kubelet metrics
      ];
      allowedUDPPorts = [
        53 # DNS
        8472 # cilium - vxlan
        51871 # cilium - wireguard
      ];
    };
  };
}
