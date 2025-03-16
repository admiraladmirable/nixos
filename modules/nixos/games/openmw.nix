{
  config,
  lib,
  pkgs,
  openmw-nix,
  ...
}:
with lib;
{
  options.openmw.enable = mkEnableOption "Enable openmw";

  # config = mkIf config.openmw.enable {
  #   # environment.systemPackages = with openmw-nix.packages.
  #   programs.openmw-nix
  # };
}
