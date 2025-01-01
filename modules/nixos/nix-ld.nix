{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.nix-ld.enable = mkEnableOption "Enable nix-ld";

  config = mkIf config.nix-ld.enable {
    programs.nix-ld.dev.enable = true;
  };
}

