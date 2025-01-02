{ pkgs, lib, ... }:
with lib;
{
  imports = [
    ./display
    ./ops/k8s.nix
    ./ops/QEMU.nix
    ./ops/docker.nix
    ./ops/gnupg.nix
    # ./nvim
    ./steam.nix
    ./deluge.nix
    ./coolercontrol.nix
    ./nix-ld.nix
  ];
}
