{ inputs, ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        enableBashIntegration = true;
        package = inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default;
        settings = {
          window-decoration = "server";
        };
      };
    };
}
