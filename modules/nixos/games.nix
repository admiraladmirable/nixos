{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.games.enable = mkEnableOption "Enable games";

  config = mkIf config.games.enable {
    users.users.rick-desktop = {
      packages = with pkgs; [
        pcsx2
        tintin
        cataclysm-dda-git
        gzdoom
      ];
    };
  };
}
