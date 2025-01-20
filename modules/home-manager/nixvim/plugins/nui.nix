{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.nixvim = {
    plugins.nui = {
      enable = true;
    };
  };
}
