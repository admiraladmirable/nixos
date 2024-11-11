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
  kde.enable = false;
  k8s.enable = true;
  steam.enable = false;

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
    name = "iqn.2020-08.org.linux-iscsi.initiatorhost:homelab";
  };

  # Bootloader
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest; # Use latest to get HDR fixes in

    initrd.luks.devices."luks-42a74edf-5a60-4c8d-990c-82f88540ef5c".device = "/dev/disk/by-uuid/42a74edf-5a60-4c8d-990c-82f88540ef5c";
  };

  # Networking
  networking = {
    hostName = "homelab";
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

  # Enable OpenGL/Graphics
  # hardware = {
  #   graphics = {
  #     enable = true;
  #     enable32Bit = true;
  #   };

  #   enableRedistributableFirmware = true;
  #   pulseaudio.enable = false;

  #   nvidia = {
  #     modesetting.enable = true;
  #     powerManagement.enable = true;
  #     powerManagement.finegrained = false;
  #     nvidiaSettings = true;
  #     package = config.boot.kernelPackages.nvidiaPackages.latest;
  #     open = true;
  #     # package = config.boot.kernelPackages.nvidiaPackages.beta;
  #     # package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
  #     #     version = "555.42.02";
  #     #     sha256_64bit = "sha256-k7cI3ZDlKp4mT46jMkLaIrc2YUx1lh1wj/J4SVSHWyk=";
  #     #     sha256_aarch64 = lib.fakeSha256;
  #     #     openSha256 = lib.fakeSha256;
  #     #     settingsSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
  #     #     persistencedSha256 = "sha256-rtDxQjClJ+gyrCLvdZlT56YyHQ4sbaL+d5tL4L4VfkA=";
  #     # };
  #   };
  # };

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

  # Enable OpenGL/Graphics
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    enableRedistributableFirmware = true;
    pulseaudio.enable = false;

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      powerManagement.finegrained = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.latest;
      open = true;
    };
  };

  services = {
    xserver = {
      videoDrivers = [ "nvidia" ];
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
    kitty
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

  # Open ports in the firewall.
  networking.firewall = {
    allowedTCPPorts = [
      22 # ssh
      6443 # k3s api
      80 # http
      443 # https
    ];
    # allowedUDPPorts = [ 5353 ];
    enable = true;
  };
}
