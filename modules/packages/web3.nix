{ ... }:
{
  # The `web3` nixos facet (hardware.ledger.enable) lives in
  # modules/hardware/ledger.nix so hardware concerns stay under hardware/.
  flake.modules.homeManager.web3 =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        foundry
      ];
    };
}
