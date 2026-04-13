{ ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      nix = {
        package = pkgs.nixVersions.stable;
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
          ];
          auto-optimise-store = true;
          trusted-users = [ "rmrf" ];
        };
        gc = {
          automatic = true;
          dates = "daily";
          options = "--delete-older-than 30d";
        };
      };
    };
}
