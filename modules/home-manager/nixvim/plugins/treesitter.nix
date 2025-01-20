{
  pkgs,
  lib,
  inputs,
  ...
}:
{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;

      settings = {
        highlight.enable = true;
      };
    };
    plugins.treesitter-textobjects = {
      enable = true;
    };
  };
}
