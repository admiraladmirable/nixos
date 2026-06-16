{ ... }:
{
  flake.modules.nixos.work =
    { lib, pkgs, ... }:
    {
      home-manager.users.rmrf.desktop.shell = "noctalia";
      home-manager.users.rmrf.desktop.hyprland.monitors = [
        "eDP-2, highrr, auto-right, 1.33"
        "DP-1, highrr, auto-left, 1"
        # "DP-1, highrr, auto-left, 1"
        ", preferred, auto, 1"
      ];
      # TODO: Revert when going home
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

      # The graphics mitigations dcdebugmask=0x410 / sg_display=0 / abmlevel=0
      # come from nixos-hardware's framework-16-amd-ai-300-series module
      # (imported via modules/hardware/framework16-amd-ai-300.nix), so they are
      # not repeated here. See
      # https://gist.github.com/lbrame/f9034b1a9fe4fc2d2835c5542acb170a#user-content-quick-version-apply-the-mitigations-i-am-personally-using
      boot.kernelParams = [
        # Recover a hung dGPU instead of wedging the whole machine: turns a
        # black-screen-forever (requiring a power-button hold) into a brief
        # flicker, and lets the ring-timeout fault actually persist to the journal.
        "amdgpu.gpu_recovery=1"
      ];

      # # Keep the RX 7700S dGPU (PCI 1002:7480) out of D3cold runtime suspend.
      # # The rear USB-C ports route their DisplayPort outputs through the dGPU,
      # # and those connectors (DP-10/DP-11) only enumerate while it's in D0. When
      # # it runtime-suspends the connectors disappear and an external-monitor
      # # hotplug can't wake it -> "no signal", nothing detected. Pinning power
      # # control to "on" keeps the outputs live so cold-plug works. Targeted by
      # # PCI ID so it survives bus-path changes and never touches the iGPU.
      # # Trade-off: a few watts of idle battery when mobile with no monitor.
      # services.udev.extraRules = ''
      #   ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x1002", ATTR{device}=="0x7480", ATTR{power/control}="on"
      # '';

      hardware = {
        enableRedistributableFirmware = true;
        graphics.enable = true;
      };

      services.xserver = {
        enable = true;
        videoDrivers = [ "modesetting" ];
        # The internal panel is wired to the 890M iGPU. Without this, Xorg
        # can pick the RX 7700S dGPU and render SDDM to a disconnected screen.
        deviceSection = ''
          BusID "PCI:196:0:0"
          Option "PrimaryGPU" "yes"
        '';
        xkb.layout = "us";
        xkb.variant = "";
      };

      # Keep the greeter off Wayland on this host; the Wayland SDDM
      # compositor can fail to light up the internal panel by itself.
      services.displayManager.sddm.wayland.enable = lib.mkForce false;

      networking.firewall = {
        enable = true;
        allowedUDPPorts = [
          4242
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
