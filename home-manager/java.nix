{ pkgs, inputs, ... }:

{
  programs.java = {
    enable = true;
    package = pkgs.jdk17;
  };
}
