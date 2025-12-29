{
  pkgs ? import <nixpkgs> { },
  ...
}:
rec {
  falcon-sensor = pkgs.callPackage ./falcon-sensor { };
}
