{ pkgs, inputs, ... }:

{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      donjayamanne.githistory
      eamodio.gitlens
      GulajavaMinistudio.mayukaithemevsc
      nhoizey.gremlins
      scalameta.metals
    ];
  };
}
