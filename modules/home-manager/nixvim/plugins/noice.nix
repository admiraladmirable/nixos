{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.nixvim = {
    plugins.noice = {
      enable = true;
    };
  };
}
