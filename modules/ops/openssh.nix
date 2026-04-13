{ ... }:
{
  flake.modules.nixos.server = {
    services.openssh.enable = true;
  };
}
