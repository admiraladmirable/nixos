{ inputs, config, ... }:
{
  flake.overlays.default = import ../../pkgs/default.nix;

  flake.modules.nixos.base = {
    nixpkgs.overlays = [
      config.flake.overlays.default
      inputs.claude-code-nix.overlays.default
    ];
    nixpkgs.config.allowUnfree = true;
  };
}
