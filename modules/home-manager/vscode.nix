{ pkgs, inputs, ... }:
{
  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      donjayamanne.githistory
      eamodio.gitlens
      rust-lang.rust-analyzer
      vadimcn.vscode-lldb
      scalameta.metals
    ];
  };
}
