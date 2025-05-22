{
  pkgs ? import <nixpkgs> { },
}:

pkgs.callPackage ./tes3cmd.nix { }
