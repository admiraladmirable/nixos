{ pkgs, lib, inputs, ... }:
{
  programs.nixvim = {
    plugins.notify = {
      enable = true;
    };
  };
}
