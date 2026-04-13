{ ... }:
{
  flake.modules.nixos.homelab1 =
    {
      config,
      pkgs,
      ...
    }:
    {
      system.stateVersion = "23.05";
      networking.hostName = "homelab-1";

      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxPackages_latest;
      };

      services.udisks2.enable = true;
      security.rtkit.enable = true;
      services.pulseaudio.enable = false;

      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
        };
        enableRedistributableFirmware = true;
      };

      services.xserver = {
        xkb.layout = "us";
        xkb.variant = "";
      };

      users.users.rmrf.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJWrrtZwPBfXwYZ50IaXjpakushKItfjToNNIOFLigP9 rmrf@desktop"
      ];

      fonts.packages = with pkgs; [ source-code-pro ];

      environment.variables = {
        FLAKE = "/home/rmrf/.config/nixos/";
      };

      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
      };

      environment.systemPackages = with pkgs; [
        xclip
      ];

      boot.kernel.sysctl = {
        "net.ipv4.ipv4_forward" = true;
      };

      networking.firewall = {
        enable = false;
        checkReversePath = false;
        allowedTCPPorts = [
          22
          53
          6443
          2379
          2340
          80
          443
          4240
          4244
          4245
          4250
          4251
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
          10250
        ];
        allowedUDPPorts = [
          53
          8472
          51871
        ];
      };
    };
}
