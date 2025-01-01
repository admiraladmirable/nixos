{ lib, ... }:
with lib;
{
  imports = [
    ./kde.nix
    ./gpu-screen-recorder.nix
  ];
}
