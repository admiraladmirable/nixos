{
  pkgs,
  ...
}:
{
  imports = [
    ./autocmd.nix
    ./keymaps.nix
    ./lazy.nix
    ./settings.nix

    ./plugins
  ];

  programs.nixvim = {
    enable = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    extraPlugins = with pkgs; [
      vimPlugins.nvzone-typr
    ];
  };
}
