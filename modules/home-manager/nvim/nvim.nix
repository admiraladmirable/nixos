{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    # Aliases
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withNodeJs = true;
    coc = {
      enable = true;
    };

    extraLuaConfig = /* lua */ ''
      vim.g.mapleader = " "

      ${builtins.readFile ./lua/options.lua}
    '';

    extraPackages = with pkgs; [
      lua-language-server
      rnix-lsp
      tree-sitter
      ripgrep
    ];

    plugins = let
      nvim-treesitter-with-plugins = pkgs.vimPlugins.nvim-treesitter.withPlugins (treesitter-plugins:
        with treesitter-plugins; [
          bash
          lua
          nix
          python
          rust
          scala
          json
        ]);
    in
      with pkgs.vimPlugins; [
        nvim-treesitter-with-plugins
        {
          plugin = nvim-lspconfig
          type = "lua";
          config = ''
            require'lspconfig'.pyright.setup{}
          '';
        }
        {
          plugin = nlsp-settings.nvim
          type = "lua";
          config = ''
            
          '';
        }
        cmp-buffer
        cmp-nvim-lsp
        cmp-path
        luasnip
        nvim-cmp
        lualine-nvim
        which-key-nvim
        {
          plugin = comment-nvim
          type = "lua";
        }
        symbols-outline-nvim
        vim-illuminate
        nvim-autopairs
        gitsigns-nvim
        indent-blankline-nvim
        bufferline-nvim
        nvim-treesitter.withAllGrammars
        plenary-nvim
        catppuccin-nvim
        telescope-nvim
        nvim-dap
        neo-tree-nvim
        nvim-cmp
        trouble-nvim
        none-ls-nvim
        popup-nvim
        friendly-snippets
        lazydev-nvim
        nvim-tree-lua
        telescope-live-grep-args-nvim
        {
          plugin = alpha-nvim;
          type = "lua";
          config = ''
            require'alpha'.setup(require'alpha.themes.dashboard'.config)
          '';
        }
        
        # Icons
        mini-icons
        nvim-web-devicons
        # Additional nice to haves
        toggleterm-nvim
      ];
  };
}