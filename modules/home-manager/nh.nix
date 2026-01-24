{ pkgs, inputs, ... }:
{
  programs.nh = {
    enable = true;
    clean.enable = true;
    # flake = "/home/rmrf/.config/nixos"
  };
}
