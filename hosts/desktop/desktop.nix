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
  xorg.enable = true;
  kde.enable = true;
  gui.hyprland.enable = true;
  k8.enable = true;
  steam.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  hardware.enableRedistributableFirmware = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.luks.devices."luks-be262eb3-9e45-4c67-a7b4-f9d9ddfa16c5".device = "/dev/disk/by-uuid/be262eb3-9e45-4c67-a7b4-f9d9ddfa16c5";

  # Networking
  networking.hostName = "desktop";
  networking.networkmanager.enable = true;

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

  # Enable OpenGL
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  # Linux Kernel
  boot.kernelPackages = pkgs.linuxPackages_latest; # Use latest to get HDR fixes in 

  # Nvidia GPU Drivers
  hardware.nvidia = {
    modesetting.enable = true;
    # powerManagement.enable = true;
    # powerManagement.finegrained = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  #boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 1;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Disable SSH for now.
  # services.openssh.enable = lib.mkForce false;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.users.rick-desktop = {
    isNormalUser = true;
    description = "Rick Morrow";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "dialout"
    ];
  };

  fonts.packages = with pkgs; [ source-code-pro ];

  environment.variables = {
    FLAKE = "/home/rick-desktop/.config/nixos/";
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
    slack
    xclip
    nil
    vesktop
    obsidian
    spotify
    protonup
    mangohud
    nh
  ];

  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 30d";

  # networking.extraHosts =
  # ''127.0.0.1 scaleosaurus.com'';

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 57621 ];
  networking.firewall.allowedUDPPorts = [ 5353 ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
