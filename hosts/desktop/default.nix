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
  # kde.enable = true;
  hyprland.enable = true;
  stylix-module.enable = true;
  # k8s.enable = false;
  steam.enable = true;
  coolercontrol.enable = true;
  gpu-screen-recorder.enable = true;
  gamemode.enable = true;

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

    # https://www.reddit.com/r/NixOS/comments/1emk6sr/nixos_is_awesome_and_a_little_guide_on_using/
    kernelParams = [
      "amd_pstate=guided"
      # Enable Real Time
      "PREEMPT_RT"
    ];

    kernelPackages = pkgs.linuxPackages_latest; # Use latest to get HDR fixes in
    initrd.luks.devices."luks-be262eb3-9e45-4c67-a7b4-f9d9ddfa16c5".device =
      "/dev/disk/by-uuid/be262eb3-9e45-4c67-a7b4-f9d9ddfa16c5";
  };

  powerManagement = {
    cpuFreqGovernor = "schedutil";
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
      extraPackages = with pkgs; [
        nvidia-vaapi-driver
      ];
    };

    enableRedistributableFirmware = true;

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      nvidiaSettings = true;
      # package = config.boot.kernelPackages.nvidiaPackages.latest;
      open = true;
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "575.51.02";
        sha256_64bit = "sha256-XZ0N8ISmoAC8p28DrGHk/YN1rJsInJ2dZNL8O+Tuaa0=";
        sha256_aarch64 = "sha256-NNeQU9sPfH1sq3d5RUq1MWT6+7mTo1SpVfzabYSVMVI=";
        openSha256 = "sha256-NQg+QDm9Gt+5bapbUO96UFsPnz1hG1dtEwT/g/vKHkw=";
        settingsSha256 = "sha256-6n9mVkEL39wJj5FB1HBml7TTJhNAhS/j5hqpNGFQE4w=";
        persistencedSha256 = "sha256-dgmco+clEIY8bedxHC4wp+fH5JavTzyI1BI8BxoeJJI=";
      };
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
      "gamemode"
      "audio"
    ];

    hashedPassword = "$6$dAbP8R68N39TelAh$8TagDN12cSuGOrCvz9pCvKBwJzaJochIj1HE70MbDcPXeTyrfHXfUdy3Mo7E4ZtCvHWjJyFyr7j6crQBUZn.h/";
    # openssh.authorizedKeys.keys = [
    #   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWrrtZwPBfXwYZ50IaXjpakushKItfjToNNIOFLigP9 rmrf@desktop"
    # ];
  };

  fonts.packages = with pkgs; [
    source-code-pro
    nerd-fonts.fira-code
  ];

  environment.variables = {
    NH_FLAKE = "/home/rmrf/.config/nixos/";
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_USE_XINPUT2 = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    # Not sure if we need these
    NVD_BACKEND = "direct";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  environment.systemPackages = with pkgs; [
    libva-utils
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
        wine-wayland
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
    winetricks
    protontricks
    wine
    wine64
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

  # Open ports in the firewall.
  networking = {
    hosts = {
      "10.0.0.19" = [ "homelab-0" ];
      "10.0.0.21" = [ "desktop" ];
      "10.0.0.26" = [ "homelab-1" ];
      "10.0.0.24" = [ "work" ];
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
