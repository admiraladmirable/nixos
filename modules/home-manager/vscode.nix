{ pkgs, inputs, ... }:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      # Nix
      jnoortheen.nix-ide
      arrterian.nix-env-selector
      bbenoist.nix
      mkhl.direnv
      # General
      donjayamanne.githistory
      eamodio.gitlens
      # Rust
      # rust-lang.rust-analyzer
      # vadimcn.vscode-lldb
      # fill-labs.dependi
      # # Go
      # golang.go
    ];
  };
}
