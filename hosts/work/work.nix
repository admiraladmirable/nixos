{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ../../modules
    ./hardware-configuration.nix
  ];
  # programs.zsh.enable=true;
  docker.enable = true;
  games.enable = true;
  xorg.enable = true;
  kde.enable = true;
  gui.hyprland.enable = true;
  xrdp.enable = true;
  k8.enable = true;
  # users.defaultUserShell = pkgs.bash;

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

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "nixos";
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

  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  networking.firewall = {
    enable = false;
    allowedTCPPorts = [2049 4000 4001 4002 5050 5432 5433 20048 31190];
    allowedUDPPorts = [2049 4000 4001 4002 5050 5432 5433 20048 31190];
  };

  #boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 1;

  # Enable CUPS to print documents.
  services.printing.enable = true;

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

  users.users.rick-topl = {
    isNormalUser = true;
    description = "Rick Morrow - Work";
    extraGroups = ["networkmanager" "wheel" "docker" "dialout"];
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
    rustdesk-server
    rustdesk
    slack
    xclip
  ];

  # systemd.tmpfiles.rules = [
  #     "d /opt/rustdesk 0700 root root"
  #     "d /var/log/rustdesk 0700 root root"
  #     # optional (only for [Erase Your Darlings](https://grahamc.com/blog/erase-your-darlings) or [tmpfs as root](https://elis.nu/blog/2020/05/nixos-tmpfs-as-root/) setups):
  #     "L /opt/rustdesk/db_v2.sqlite3 - - - - /persist/opt/rustdesk/db_v2.sqlite3"
  #     "L /opt/rustdesk/db_v2.sqlite3-shm - - - - /persist/opt/rustdesk/db_v2.sqlite3-shm"
  #     "L /opt/rustdesk/db_v2.sqlite3-wal - - - - /persist/opt/rustdesk/db_v2.sqlite3-wal"
  #     "L /opt/rustdesk/id_ed25519 - - - - /persist/opt/rustdesk/id_ed25519"
  #     "L /opt/rustdesk/id_ed25519.pub - - - - /persist/opt/rustdesk/id_ed25519.pub"
  #   ];

  #   systemd.services.rustdesksignal = {
  #     description = "Rustdesk Signal Server (hbbs)";
  #     documentation = [
  #       "https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/install/"
  #       "https://github.com/techahold/rustdeskinstall/blob/master/install.sh"
  #     ];
  #     after = [ "network-pre.target" ];
  #     wants = [ "network-pre.target" ];
  #     partOf = [ "rustdeskrelay.service" ];
  #     wantedBy = [ "multi-user.target" ];
  #     serviceConfig = {
  #       Type = "simple";
  #       LimitNOFILE=1000000;
  #       WorkingDirectory="/opt/rustdesk";
  #       StandardOutput="append:/var/log/rustdesk/hbbs.log";
  #       StandardError="append:/var/log/rustdesk/hbbs.error";
  #       ExecStart="${pkgs.rustdesk-server}/bin/hbbs -r localhost:21117";
  #       Restart="always";
  #       RestartSec=10;
  #     };
  #     #script = with pkgs; ''
  #     #'';
  #   };

  #   systemd.services.rustdeskrelay = {
  #     description = "Rustdesk Relay Server (hbbr)";
  #     documentation = [
  #       "https://rustdesk.com/docs/en/self-host/rustdesk-server-oss/install/"
  #       "https://github.com/techahold/rustdeskinstall/blob/master/install.sh"
  #     ];
  #     after = [ "network-pre.target" ];
  #     wants = [ "network-pre.target" ];
  #     partOf = [ "rustdesksignal.service" ];
  #     wantedBy = [ "multi-user.target" ];
  #     serviceConfig = {
  #       Type = "simple";
  #       LimitNOFILE=1000000;
  #       WorkingDirectory="/opt/rustdesk";
  #       StandardOutput="append:/var/log/rustdesk/hbbr.log";
  #       StandardError="append:/var/log/rustdesk/hbbr.error";
  #       ExecStart="${pkgs.rustdesk-server}/bin/hbbr";
  #       Restart="always";
  #       RestartSec=10;
  #     };
  #script = with pkgs; ''
  #'';
  # };

  nix.settings.auto-optimise-store = true;
  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 30d";

  # networking.extraHosts =
  # ''127.0.0.1 scaleosaurus.com'';
}
