{ pkgs, lib, inputs, ... }:
{
  imports = [
    ./plugins/alpha.nix
    ./plugins/autocmds.nix
    ./plugins/autopairs.nix
    ./plugins/bufferline.nix
    ./plugins/commands.nix
    ./plugins/comment.nix
    ./plugins/conform-nvim.nix
    ./plugins/dap.nix
    ./plugins/dressing.nix
    ./plugins/fidget.nix
    ./plugins/fugitive.nix
    ./plugins/gitsigns.nix
    ./plugins/guess-indent.nix
    ./plugins/illuminate.nix
    ./plugins/indent-blankline.nix
    ./plugins/keymaps.nix
    ./plugins/lint.nix
    ./plugins/lsp.nix
    ./plugins/lualine.nix
    ./plugins/markdown-preview.nix
    ./plugins/neoscroll.nix
    ./plugins/none-ls.nix
    ./plugins/notify.nix
    ./plugins/nvim-cmp.nix
    ./plugins/nvim-tree.nix
    ./plugins/project-nvim.nix
    ./plugins/rustaceanvim.nix
    ./plugins/sleuth.nix
    ./plugins/telescope.nix
    ./plugins/todo-comments.nix
    ./plugins/toggleterm.nix
    ./plugins/treesitter.nix
    ./plugins/web-devicons.nix
    ./plugins/which-key.nix
  ];

  programs.nixvim = {
    enable = true;

    colorschemes.catppuccin.enable = true;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    clipboard = {
      providers = {
        wl-copy.enable = true; # For Wayland
      };

      # Sync clipboard between OS and Neovim
      register = "unnamedplus";
    };

    opts = {
      number = true;
      mouse = "a";
      showmode = false;
      undofile = true;
      ignorecase = true;
      smartcase = true;
      signcolumn = "yes";
      updatetime = 250;
      timeoutlen = 300;
      splitright = true;
      splitbelow = true;
      list = true;
      listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";
      inccommand = "split";
      cursorline = true;
      scrolloff = 10;
      hlsearch = true;
    };

    # https://nix-community.github.io/nixvim/NeovimOptions/autoGroups/index.html
    autoGroups = {
      kickstart-highlight-yank = {
        clear = true;
      };
    };

    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraplugins
    # extraPlugins = with pkgs.vimPlugins; [
    # ];

    # TODO: Figure out where to move this
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraconfigluapre
    extraConfigLuaPre = ''
      if vim.g.have_nerd_font then
        require('nvim-web-devicons').setup {}
      end
    '';

    # The line beneath this is called `modeline`. See `:help modeline`
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraplugins#extraconfigluapost
    extraConfigLuaPost = ''
      -- vim: ts=2 sts=2 sw=2 et
    '';
  };
}

