{ ... }:
{
  flake.modules.nixos.base = {
    virtualisation.docker.enable = true;

    # docker-sbx's nerdbox shim creates loop devices to mount per-sandbox
    # rwlayer images. Default NixOS perms are root:disk 0660 — grant the
    # kvm group (already trusted for VM access) instead of widening to disk.
    services.udev.extraRules = ''
      KERNEL=="loop-control", GROUP="kvm", MODE="0660"
      KERNEL=="loop[0-9]*", GROUP="kvm", MODE="0660"
    '';
  };

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        docker-compose
        docker-sbx
      ];
    };
}
