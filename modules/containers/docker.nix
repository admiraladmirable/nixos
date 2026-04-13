{ ... }:
{
  flake.modules.nixos.base = {
    virtualisation.docker.enable = true;
  };
}
