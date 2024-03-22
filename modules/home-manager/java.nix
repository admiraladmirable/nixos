{ pkgs, inputs, config, ... }: {
  programs.java = {
    enable = false;
    package = pkgs.graalvm-ce;
  };
}
