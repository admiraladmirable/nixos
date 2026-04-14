{ ... }:
{
  flake.modules.nixos.base = {
    virtualisation.docker.enable = true;
  };

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [ docker-compose ];
    };
}
