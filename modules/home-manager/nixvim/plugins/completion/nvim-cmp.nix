{
  programs.nixvim = {
    plugins.friendly-snippets.enable = true;
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

        window = {
          completion = {
            border = "rounded";
            scrollbar = true;
          };
          documentation.border = "rounded";
        };
        experimental.ghost_text = true;

        mapping = {
          "<Tab>".__raw = ''
            cmp.mapping(function(fallback)
              local luasnip = require("luasnip")
              if luasnip.locally_jumpable(1) then
                luasnip.jump(1)
              else
                fallback()
              end
            end, { "i", "s" })
          '';

          "<S-Tab>".__raw = ''
            cmp.mapping(function(fallback)
              local luasnip = require("luasnip")
              if luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" })
          '';

          "<C-n>" = # lua
            "cmp.mapping(cmp.mapping.select_next_item())";
          "<C-p>" = # lua
            "cmp.mapping(cmp.mapping.select_prev_item())";
          "<C-e>" = # lua
            "cmp.mapping.abort()";
          "<C-d>" = # lua
            "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = # lua
            "cmp.mapping.scroll_docs(4)";
          "<Up>" = # lua
            "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
          "<Down>" = # lua
            "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
          "<CR>" = # lua
            "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Insert, select = true })";
          "<C-Space>" = # lua
            "cmp.mapping.complete()";
        };

        sources = [
          { name = "nvim_lsp"; }
          { name = "nvim_lsp_signature_help"; }
          { name = "nvim_lsp_document_syntax"; }
          { name = "path"; }
          # { name = "codeium"; }
          { name = "buffer"; }
          { name = "cmp-git"; }
          { name = "luasnip"; }
          { name = "nvim_lua"; }
          { name = "calc"; }
          { name = "emoji"; }
          { name = "treesitter"; }
          { name = "crates"; }
        ];
      };
    };
  };
}
