{ config, pkgs, lib, ...}:

{
  imports =
    [       
      ../modules
    ];
    programs.zsh.enable=true;
    docker.enable = true;
    games.enable = true;
    deluge.enable = true;
    xorg.enable = true;
    kde.enable = true;
    k8.enable = true;
    users.defaultUserShell = pkgs.zsh;

  system.stateVersion = "22.11"; # Did you read the comment?

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = "experimental-features = nix-command flakes";
  };

  hardware.enableRedistributableFirmware = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "buddha";
  networking.networkmanager.enable = true;

  time.timeZone = "America/Los_Angeles";
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

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [ 2049 4000 4001 4002 5050 5432 5433 20048 31190];
    allowedUDPPorts = [ 2049 4000 4001 4002 5050 5432 5433 20048 31190];

  };

  #boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 1;

  hardware.bluetooth.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  users.users.senoraraton = {
    isNormalUser = true;
    description = "Claus";
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout" ];
  };

  fonts.packages = with pkgs; [
    source-code-pro
  ];
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
	zsh
	gnumake
    cmake
	gcc
    gdb
	python3Full
    go
	rustc
	cargo
	nodejs
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
    nodePackages.npm
    python310Packages.pip
    sqlite
    traceroute
    poppler_utils
    nmap
    bat
  ];

  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 7d";

  networking.extraHosts =
  ''127.0.0.1 scaleosaurus.com'';


  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/c58d9473-389e-4404-830c-917508f39b13";
      fsType = "ext4";
    };

  fileSystems."/boot/efi" =
    { device = "/dev/disk/by-uuid/8F92-A776";
      fsType = "vfat";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/cce8f689-0494-40d6-b9c7-f0e968ced733"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp2s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
