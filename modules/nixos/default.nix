{ lib, ... }:
with lib;
{
  imports = [
    ./display
    ./ops/k8s.nix
    ./ops/QEMU.nix
    ./ops/docker.nix
    # ./nvim
    ./steam.nix
    ./deluge.nix
    ./coolercontrol.nix
  ];
}
