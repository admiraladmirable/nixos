{ config, lib, pkgs, ... }:
with lib; {
  options.qemu.enable = mkEnableOption "Enable QEMU";

  config = mkIf config.qemu.enable {
    boot.kernelModules = [ "kvm-intel" "overlay" ];
    virtualisation.libvirtd.enable = true;
    users.users.rick-topl.extraGroups = [ "libvirtd" ];

    environment.systemPackages = with pkgs; [
      libvirt
      virt-manager
      virt-top
      qemu
      bridge-utils
    ];
  };
}
