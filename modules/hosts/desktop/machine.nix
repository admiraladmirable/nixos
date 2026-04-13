{ inputs, ... }:
{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      # home-manager.users.rmrf.desktop.shell = "caelestia";
      home-manager.users.rmrf.desktop.shell = "noctalia";

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

      security.polkit.enable = true;

      systemd.user.services.polkit-kde-agent = {
        description = "KDE polkit authentication agent";
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
          Restart = "on-failure";
        };
      };

      environment.variables = {
        NH_FLAKE = "/home/rmrf/.config/nixos/";
      };
    };
}
