{ pkgs, lib, ... }:
with lib;
{
  imports = [
    ./display
    ./ops/k3s-agent.nix
    ./ops/k3s-server.nix
    ./ops/QEMU.nix
    ./ops/docker.nix
    ./ops/gnupg.nix
    ./ops/yubikey.nix
    ./ops/openvpn3.nix
    ./ops/awsclientvpn.nix
    # ./nvim
    ./steam.nix
    ./games/gamemode.nix
    ./deluge.nix
    ./coolercontrol.nix
    ./nix-ld.nix
    # ./falcon-sensor.nix
  ];
}
