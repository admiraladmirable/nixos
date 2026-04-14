{ ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      hardware.ledger.enable = true;
    };
}
