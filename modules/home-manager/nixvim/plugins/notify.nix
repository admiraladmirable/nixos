{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.nixvim = {
    plugins.notify = {
      enable = true;
      timeout = 1;
      # fps = 144;
    };
  };
}
