{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      programs.vscode = {
        enable = true;
        profiles.default.extensions = with pkgs.vscode-extensions; [
          jnoortheen.nix-ide
          arrterian.nix-env-selector
          bbenoist.nix
          mkhl.direnv
          donjayamanne.githistory
          eamodio.gitlens
        ];
      };
    };
}
