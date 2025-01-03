{
  programs.nixvim = {
    # `friendly-snippets` contains a variety of premade snippets
    #    See the README about individual language/framework/plugin snippets:
    #    https://github.com/rafamadriz/friendly-snippets
    # https://nix-community.github.io/nixvim/plugins/friendly-snippets.html
    plugins.friendly-snippets = {
      enable = true;
    };

    plugins.luasnip.enable = true;

    # Autocompletion
    # See `:help cmp`
    # https://nix-community.github.io/nixvim/plugins/cmp/index.html
    plugins.cmp = {
      enable = true;

      settings = {
        snippet = {
          expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
        };

        completion = {
          completeopt = "menu,menuone,noinsert";
        };

        # For an understanding of why these mappings were
        # chosen, you will need to read `:help ins-completion`
        #
        # No, but seriously, Please read `:help ins-completion`, it is really good!
        mapping = {
          # Select the [n]ext item
          "<C-n>" = "cmp.mapping.select_next_item()";
          # Select the [p]revious item
          "<C-p>" = "cmp.mapping.select_prev_item()";
          # Scroll the documentation window [b]ack / [f]orward
          "<C-b>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          # Accept ([y]es) the completion.
          #  This will auto-import if your LSP supports it.
          #  This will expand snippets if the LSP sent a snippet.
          # "<C-y>" = "cmp.mapping.confirm { select = true }";
          # If you prefer more traditional completion keymaps,
          # you can uncomment the following lines.
          "<CR>" = "cmp.mapping.confirm { select = true }";
          # "<Tab>" = "cmp.mapping.select_next_item()";
          # "<S-Tab>" = "cmp.mapping.select_prev_item()";

          # Manually trigger a completion from nvim-cmp.
          #  Generally you don't need this, because nvim-cmp will display
          #  completions whenever it has completion options available.
          "<C-Space>" = "cmp.mapping.complete {}";

          # Think of <c-l> as moving to the right of your snippet expansion.
          #  So if you have a snippet that's like:
          #  function $name($args)
          #    $body
          #  end
          #
          # <c-l> will move you to the right of the expansion locations.
          # <c-h> is similar, except moving you backwards.
          "<C-l>" = ''
            cmp.mapping(function()
              if luasnip.expand_or_locally_jumpable() then
                luasnip.expand_or_jump()
              end
            end, { 'i', 's' })
          '';
          "<C-h>" = ''
            cmp.mapping(function()
              if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              end
            end, { 'i', 's' })
          '';

          # For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
          #    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
        };

        # Dependencies
        # sources = [
        #   {
        #     pluginName = "cmp-async-path";
        #     sourceName = "async_path";
        #   }
        #   {
        #     pluginName = "cmp-buffer";
        #     sourceName = "buffer";
        #   }
        #   {
        #     pluginName = "cmp-calc";
        #     sourceName = "calc";
        #   }
        #   {
        #     pluginName = "cmp-clippy";
        #     sourceName = "cmp-clippy";
        #   }
        #   {
        #     pluginName = "cmp-cmdline";
        #     sourceName = "cmdline";
        #   }
        #   {
        #     pluginName = "cmp-cmdline-history";
        #     sourceName = "cmp-cmdline-history";
        #   }
        #   {
        #     pluginName = "cmp-conventionalcommits";
        #     sourceName = "conventionalcommits";
        #   }
        #   {
        #     pluginName = "cmp-dap";
        #     sourceName = "dap";
        #   }
        #   {
        #     pluginName = "cmp-dictionary";
        #     sourceName = "dictionary";
        #   }
        #   {
        #     pluginName = "cmp-digraphs";
        #     sourceName = "digraphs";
        #   }
        #   {
        #     pluginName = "cmp-emoji";
        #     sourceName = "emoji";
        #   }
        #   {
        #     pluginName = "cmp-fuzzy-buffer";
        #     sourceName = "fuzzy_buffer";
        #   }
        #   {
        #     pluginName = "cmp-fuzzy-path";
        #     sourceName = "fuzzy_path";
        #   }
        #   {
        #     pluginName = "cmp-greek";
        #     sourceName = "greek";
        #   }
        #   {
        #     pluginName = "cmp-latex-symbols";
        #     sourceName = "latex_symbols";
        #   }
        #   {
        #     pluginName = "cmp-look";
        #     sourceName = "look";
        #   }
        #   {
        #     pluginName = "cmp_luasnip";
        #     sourceName = "luasnip";
        #   }
        #   {
        #     pluginName = "cmp-nixpkgs-maintainers";
        #     sourceName = "nixpkgs_maintainers";
        #   }
        #   {
        #     pluginName = "cmp-npm";
        #     sourceName = "npm";
        #   }
        #   {
        #     pluginName = "cmp-nvim-lsp";
        #     sourceName = "nvim_lsp";
        #   }
        #   {
        #     pluginName = "cmp-nvim-lsp-document-symbol";
        #     sourceName = "nvim_lsp_document_symbol";
        #   }
        #   {
        #     pluginName = "cmp-nvim-lsp-signature-help";
        #     sourceName = "nvim_lsp_signature_help";
        #   }
        #   {
        #     pluginName = "cmp-nvim-lua";
        #     sourceName = "nvim_lua";
        #   }
        #   {
        #     pluginName = "cmp-nvim-ultisnips";
        #     sourceName = "ultisnips";
        #   }
        #   {
        #     pluginName = "cmp-omni";
        #     sourceName = "omni";
        #   }
        #   {
        #     pluginName = "cmp-pandoc-nvim";
        #     sourceName = "cmp_pandoc";
        #   }
        #   {
        #     pluginName = "cmp-pandoc-references";
        #     sourceName = "pandoc_references";
        #   }
        #   {
        #     pluginName = "cmp-path";
        #     sourceName = "path";
        #   }
        #   {
        #     pluginName = "cmp-rg";
        #     sourceName = "rg";
        #   }
        #   {
        #     pluginName = "cmp-snippy";
        #     sourceName = "snippy";
        #   }
        #   {
        #     pluginName = "cmp-spell";
        #     sourceName = "spell";
        #   }
        #   {
        #     pluginName = "cmp-tmux";
        #     sourceName = "tmux";
        #   }
        #   {
        #     pluginName = "cmp-treesitter";
        #     sourceName = "treesitter";
        #   }
        #   {
        #     pluginName = "cmp-vim-lsp";
        #     sourceName = "vim_lsp";
        #   }
        #   {
        #     pluginName = "cmp-vimtex";
        #     sourceName = "vimtex";
        #   }
        #   {
        #     pluginName = "cmp-vimwiki-tags";
        #     sourceName = "vimwiki-tags";
        #   }
        #   {
        #     pluginName = "cmp-vsnip";
        #     sourceName = "vsnip";
        #   }
        #   {
        #     pluginName = "cmp_yanky";
        #     sourceName = "yanky";
        #   }
        # ];
      };
    };
  };
}
