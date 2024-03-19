{ pkgs, inputs, config, ... }:

{
  programs.java = {
    enable = true;
    package = pkgs.graalvm-ce;
  };
}
