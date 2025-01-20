{
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      inlayHints = true;

      servers = {
        lua_ls = {
          enable = true;
          settings.telemetry.enable = false;
        };

        bashls.enable = true;
        clangd.enable = true;
        cmake.enable = true;
        dartls.enable = true;
        docker_compose_language_service.enable = true;
        dockerls.enable = true;
        eslint.enable = true;
        helm_ls.enable = true;
        html.enable = true;
        htmx.enable = true;
        jsonls.enable = true;
        nixd.enable = true;
        tflint.enable = true;
        terraformls.enable = true;
        ts_ls.enable = true;
        ts_query_ls.enable = true;
        yamlls.enable = true;

        rust_analyzer = {
          # Disabled in favor of rustaceanvim
          enable = false;
          installCargo = false;
          installRustc = false;
        };
      };

      keymaps = {
        silent = true;
        lspBuf = {
          gd = {
            action = "definition";
            desc = "Goto Definition";
          };
          gr = {
            action = "references";
            desc = "Goto References";
          };
          gD = {
            action = "declaration";
            desc = "Goto Declaration";
          };
          gI = {
            action = "implementation";
            desc = "Goto Implementation";
          };
          gT = {
            action = "type_definition";
            desc = "Type Definition";
          };
          K = {
            action = "hover";
            desc = "Hover";
          };
          "<leader>cw" = {
            action = "workspace_symbol";
            desc = "Workspace Symbol";
          };
          "<leader>cr" = {
            action = "rename";
            desc = "Rename";
          };
          "<leader>ca" = {
            action = "code_action";
            desc = "Code Action";
          };
          "<C-k>" = {
            action = "signature_help";
            desc = "Signature Help";
          };
        };
        diagnostic = {
          "<leader>cd" = {
            action = "open_float";
            desc = "Line Diagnostics";
          };
          "[d" = {
            action = "goto_next";
            desc = "Next Diagnostic";
          };
          "]d" = {
            action = "goto_prev";
            desc = "Previous Diagnostic";
          };
        };
      };

      onAttach = ''
        vim.api.nvim_create_autocmd("LspAttach", {
          group = vim.api.nvim_create_augroup("UserLspConfig", {}),
          callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            if client.server_capabilities.inlayHintProvider then
              vim.lsp.inlay_hint.enable(false)
            end
            vim.bo[args.buf].omnifunc = "v:lua.vim.lsp.omnifunc"
          end,
        })
      '';

    };
  };
}
