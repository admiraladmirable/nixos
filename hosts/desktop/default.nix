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
  kde.enable = true;
  k8s.enable = false;
  steam.enable = true;
  coolercontrol.enable = true;
  gpu-screen-recorder.enable = true;

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

  # Bootloader
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelParams = [ "nvidia-drm.fbdev=1" ];

    kernelPackages = pkgs.linuxPackages_latest; # Use latest to get HDR fixes in

    initrd.luks.devices."luks-be262eb3-9e45-4c67-a7b4-f9d9ddfa16c5".device =
      "/dev/disk/by-uuid/be262eb3-9e45-4c67-a7b4-f9d9ddfa16c5";
  };

  # Networking
  networking = {
    hostName = "desktop";
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
  services.pulseaudio.enable = false;
  # Enable OpenGL/Graphics
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    enableRedistributableFirmware = true;

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      open = true;
      # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      #   version = "570.124.04";
      #   sha256_64bit = "sha256-G3hqS3Ei18QhbFiuQAdoik93jBlsFI2RkWOBXuENU8Q=";
      #   sha256_aarch64 = "sha256-RWPqS7ZUJH9JEAWlfHLGdqrNlavhaR1xMyzs8lJhy9U=";
      #   openSha256 = "sha256-DuVNA63+pJ8IB7Tw2gM4HbwlOh1bcDg2AN2mbEU9VPE=";
      #   settingsSha256 = "sha256-LNL0J/sYHD8vagkV1w8tb52gMtzj/F0QmJTV1cMaso8=";
      #   persistencedSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
      # };
    };
  };

  # Load nvidia driver for Xorg and Wayland
  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
      xkb.layout = "us";
      xkb.variant = "";
    };

    printing.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;
    };
  };

  # Enable sound with pipewire.
  # sound.enable = true;
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
  };

  fonts.packages = with pkgs; [
    source-code-pro
    nerd-fonts.fira-code
  ];

  environment.variables = {
    FLAKE = "/home/rmrf/.config/nixos/";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    kdePackages.xdg-desktop-portal-kde
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
    slack
    xclip
    nil
    discord
    obsidian
    spotify
    protonup
    mangohud
    nh
    (lutris.override {
      extraLibraries = pkgs: [
        # List library dependencies here
        winetricks
        wine
      ];
    })
    # bottles
    audacity
    gimp
    yt-dlp
    easyeffects
    nethack
    devenv
    steam-run
    wineWowPackages.stable
    winetricks
    renderdoc
    # (import ../../packages/kenku-fm.nix)
  ];

  nix = {
    settings = {
      auto-optimise-store = true;
    };
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 30d";
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Open ports in the firewall.
  networking = {
    hosts = {
      "10.0.0.19" = [ "homelab" ];
      "10.0.0.21" = [ "desktop" ];
      "10.0.0.26" = [ "homelab-1" ];
    };

    firewall = {
      allowedTCPPorts = [
        57621
        1119
        54545
        54546
        54547
        54548
        54549
        28890
        28891
        28892
        28893
        28894
        6112
        6113
        6114
        6443
        10250
      ];
      allowedUDPPorts = [ 5353 ];
      enable = false;
    };
  };
}
