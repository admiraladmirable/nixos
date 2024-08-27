{ lib, ... }:
with lib;
{
  imports = [
    ./display
    ./ops/k8s.nix
    ./ops/QEMU.nix
    ./ops/docker.nix
    ./games.nix
    # ./nvim
    ./steam.nix
    ./deluge.nix
  ];
}
