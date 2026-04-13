{ ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        source-code-pro
        nerd-fonts.fira-code
      ];
    };
}
