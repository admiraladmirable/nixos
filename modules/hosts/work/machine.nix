{ ... }:
{
  flake.modules.nixos.work =
    { pkgs, ... }:
    {
      system.stateVersion = "23.05";
      networking.hostName = "work";

      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxPackages_latest;
      };

      hardware = {
        enableRedistributableFirmware = true;
        graphics = {
          enable = true;
          extraPackages = with pkgs; [
            intel-vaapi-driver
            intel-media-driver
          ];
        };
      };

      services.xserver = {
        xkb.layout = "us";
        xkb.variant = "";
      };

      networking.firewall = {
        enable = false;
        allowedTCPPorts = [
          22
          2049
          4000
          4001
          4002
          5050
          5432
          5433
          20048
          31190
        ];
        allowedUDPPorts = [
          2049
          4000
          4001
          4002
          5050
          5432
          5433
          20048
          31190
        ];
      };

      services.printing.enable = false;

      services.openssh = {
        enable = false;
        ports = [ 22 ];
        settings.AllowUsers = [ "rmrf" ];
      };

      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      environment.variables = {
        FLAKE = "/home/rmrf/.config/nixos/";
      };

      environment.systemPackages = with pkgs; [
        syft
        envsubst
      ];
    };
}
