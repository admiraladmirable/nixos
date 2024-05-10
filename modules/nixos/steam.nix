{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
{
  options.steam.enable = mkEnableOption "Enable Steam";

  config = mkIf config.steam.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      gamescopeSession.enable = true;
    };
  };
}
