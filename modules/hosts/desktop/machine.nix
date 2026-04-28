{ inputs, config, ... }:
{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      # home-manager.users.rmrf.desktop.shell = "caelestia";
      home-manager.users.rmrf.desktop.shell = "noctalia";
      home-manager.users.rmrf.desktop.hyprland.monitors = [
        "DP-2, highrr, auto-right, 1"
        "DP-1, highrr, auto-left, 1"
      ];

      imports = [
        inputs.nix-ld.nixosModules.nix-ld
        inputs.musnix.nixosModules.musnix
        inputs.sops-nix.nixosModules.sops
      ];

      system.stateVersion = "23.05";

      networking.hostName = "desktop";

      boot = {
        loader = {
          systemd-boot.enable = true;
          efi.canTouchEfiVariables = true;
        };
        kernelParams = [ "amd_pstate=guided" ];
        blacklistedKernelModules = [ "amdgpu" ];
        kernelPackages = pkgs.linuxPackages_latest;
      };

      programs.nix-ld.dev.enable = true;

      environment.variables = {
        NH_FLAKE = "/home/rmrf/.config/nixos/";
      };

      home-manager.sharedModules = with config.flake.modules.homeManager; [
        easyeffects
        audioProduction
        gaming
        printing
        openmw
      ];
    };
}
