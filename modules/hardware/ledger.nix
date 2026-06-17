{ ... }:
{
  # Hardware-wallet udev support; grouped under the `web3` bundle so only
  # crypto-using hosts enable it.
  flake.modules.nixos.web3 =
    { pkgs, ... }:
    {
      hardware.ledger.enable = true;
    };
}
