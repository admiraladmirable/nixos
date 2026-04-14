{ ... }:
{
  flake.modules.nixos.steam =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
        package = pkgs.steam.override {
          extraPkgs =
            pkgs: with pkgs; [
              gamemode
            ];
        };
      };

      programs.gamemode.enable = true;
    };

  flake.modules.homeManager.gaming =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        mangohud
        goverlay
        protonplus
        faugus-launcher
        bottles
        steam-run
        winetricks
        protontricks
        wine64Packages.wayland
      ];
    };
}
