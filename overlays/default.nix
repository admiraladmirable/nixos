{ inputs ? { } }:
let
  pkgOverlay = import ../modules/pkgs/default.nix;
in
{
  pkgs = pkgOverlay;
  claude-code = inputs.claude-code-nix.overlays.default;
}
