{ ... }:
{
  flake.modules.nixos.work =
    { pkgs, ... }:
    {
      home-manager.users.rmrf.desktop.shell = "noctalia";
      home-manager.users.rmrf.desktop.hyprland.monitors = [
        "eDP-2, highrr, auto-right, 1"
        "DP-1, highrr, auto-left, 1"
      ];
      home-manager.users.rmrf.desktop.hyprland.workspaceRules = [
        "1, monitor:DP-1, default:true, persistent:true"
        "2, monitor:DP-1, persistent:true"
        "3, monitor:DP-1, persistent:true"
        "4, monitor:DP-1, persistent:true"
        "5, monitor:DP-1, persistent:true"

        "6, monitor:eDP-2, default:true, persistent:true"
        "7, monitor:eDP-2, persistent:true"
        "8, monitor:eDP-2, persistent:true"
        "9, monitor:eDP-2, persistent:true"
        "10, monitor:eDP-2, persistent:true"
      ];
      home-manager.users.rmrf.home.sessionVariables.LIBVA_DRIVER_NAME = "radeonsi";

      system.stateVersion = "23.05";
      networking.hostName = "work";

      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
        kernelPackages = pkgs.linuxPackages_latest;
      };

      # Everything is updateable through fwupd
      services.fwupd.enable = true;

      # The following mitigations fix various graphics issues
      # See https://gist.github.com/lbrame/f9034b1a9fe4fc2d2835c5542acb170a#user-content-quick-version-apply-the-mitigations-i-am-personally-using
      boot.kernelParams = [
        "amdgpu.dcdebugmask=0x410"
        "amdgpu.sg_display=0"
        "amdgpu.abmlevel=0"
      ];

      hardware = {
        enableRedistributableFirmware = true;
        graphics.enable = true;
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

      environment.variables = {
        NH_FLAKE = "/home/rmrf/.config/nixos/";
      };

      environment.systemPackages = with pkgs; [
        syft
        envsubst
      ];
    };
}
