{ ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      fonts.packages = with pkgs; [
        source-code-pro
        nerd-fonts.fira-code
        nerd-fonts.droid-sans-mono
      ];
    };

  flake.modules.homeManager.base = {
    fonts.fontconfig.enable = true;
  };
}
