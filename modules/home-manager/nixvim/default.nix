{
  pkgs,
  lib,
  inputs,
  icons,
  ...
}:
{
  imports = [
    # TODO: Figure out how to properly import this
    # ./lib
    ./plugins/alpha.nix
    ./plugins/autocmds.nix
    ./plugins/autopairs.nix
    ./plugins/bufferline.nix
    ./plugins/commands.nix
    ./plugins/comment.nix
    ./plugins/conform-nvim.nix
    ./plugins/coq.nix
    ./plugins/dap.nix
    ./plugins/dressing.nix
    ./plugins/edgy.nix
    ./plugins/fidget.nix
    ./plugins/flash.nix
    ./plugins/gitsigns.nix
    ./plugins/grug-far.nix
    ./plugins/guess-indent.nix
    ./plugins/illuminate.nix
    ./plugins/indent-blankline.nix
    ./plugins/keymaps.nix
    ./plugins/lazydev.nix
    ./plugins/lazygit.nix
    ./plugins/lint.nix
    ./plugins/lsp.nix
    ./plugins/lspkind.nix
    ./plugins/lualine.nix
    ./plugins/markdown-preview.nix
    ./plugins/neo-tree.nix
    ./plugins/neoconf.nix
    ./plugins/neoscroll.nix
    ./plugins/none-ls.nix
    ./plugins/notify.nix
    ./plugins/noice.nix
    ./plugins/nui.nix
    ./plugins/nvim-cmp.nix
    ./plugins/persistence.nix
    ./plugins/project-nvim.nix
    ./plugins/rustaceanvim.nix
    ./plugins/spectre.nix
    ./plugins/sleuth.nix
    ./plugins/snacks.nix
    ./plugins/telescope.nix
    ./plugins/todo-comments.nix
    ./plugins/toggleterm.nix
    ./plugins/treesitter.nix
    ./plugins/trouble.nix
    ./plugins/ts-autotag.nix
    ./plugins/undotree.nix
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
      # scrolloff = 10;
      hlsearch = true;

      expandtab = true;
      tabstop = 2;
      softtabstop = 2;
    };

    autoGroups = {
      kickstart-highlight-yank = {
        clear = true;
      };
    };

    extraPlugins = with pkgs; [
      vimPlugins.nvzone-typr
    ];

    extraConfigLua = ''
          local _border = "rounded"

          require('lspconfig.ui.windows').default_options = {
            border = _border
          }

          vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
            vim.lsp.handlers.hover, {
              border = _border
            }
          )

          vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
            vim.lsp.handlers.signature_help, {
              border = _border
            }
          )

          vim.diagnostic.config({
      			float = { border = "rounded" },
      			virtual_text = {
      				prefix = "",
      			},
            signs = true,
            underline = true,
            update_in_insert = true,
      		})

        --   vim.api.nvim_create_autocmd("LspAttach", {
        --   group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        --   callback = function(args)
        --     local client = vim.lsp.get_client_by_id(args.data.client_id)
        --     if client.server_capabilities.inlayHintProvider then
        --       vim.lsp.inlay_hint.enable(false)
        --     end
        --     vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
        --
        --     local opts = { buffer = args.buf }
        --     vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        --     vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        --     vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        --     vim.keymap.set("n", "gI", vim.lsp.buf.implementation, opts)
        --     vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, opts)
        --     vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        --     vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        --     vim.keymap.set("n", "<space>cw", vim.lsp.buf.workspace_symbol, opts)
        --     vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, opts)
        --     vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
        --     vim.keymap.set("n", "<space>cf", function()
        --       vim.lsp.buf.format({ async = true })
        --     end, opts)
        --     vim.keymap.set("n", "<space>cd", vim.diagnostic.open_float, opts)
        --     vim.keymap.set("n", "[d", vim.diagnostic.goto_next, opts)
        --     vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, opts)
        --   end,
        -- })
    '';
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
