{lib, ...}:
with lib; {
  imports = [
    ./display
    ./ops/k8.nix
    ./ops/QEMU.nix
    ./ops/docker.nix
    #./tui
    ./games.nix
    ./nvim
    ./deluge.nix
  ];
}
