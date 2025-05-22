{
  pkgs,
  inputs,
  openmw-nix,
  ...
}:
{
  home.packages = with openmw-nix.packages.x86_64-linux; [
    delta-plugin
    openmw-dev
    openmw-validator
    plox
    # umo
    groundcoverify
    curldl
  ];
}
