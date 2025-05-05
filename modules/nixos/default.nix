{ pkgs, lib, ... }:
with lib;
{
  imports = [
    ./display
    ./ops/k8s-agent.nix
    ./ops/k8s-server.nix
    ./ops/QEMU.nix
    ./ops/docker.nix
    ./ops/gnupg.nix
    # ./nvim
    ./steam.nix
    ./games/gamemode.nix
    ./deluge.nix
    ./coolercontrol.nix
    ./nix-ld.nix
  ];
}
