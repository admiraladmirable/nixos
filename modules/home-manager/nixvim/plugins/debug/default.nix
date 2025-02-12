{
  programs.nixvim = {
    # Shows how to use the DAP plugin to debug your code.
    #
    # Primarily focused on configuring the debugger for Go, but can
    # be extended to other languages as well. That's why it's called
    # kickstart.nixvim and not kitchen-sink.nixvim ;)
    # https://nix-community.github.io/nixvim/plugins/dap/index.html
    # plugins.dap-lldb = {
    #   enable = true;
    # };

    plugins = {
      dap.enable = true;
      dap-virtual-text.enable = true;
      dap-go.enable = true;

      dap-ui = {
        enable = true;

        # Set icons to characters that are more likely to work in every terminal.
        # Feel free to remove or use ones that you like more! :)
        # Don't feel like these are good choices.
        settings = {
          icons = {
            expanded = "▾";
            collapsed = "▸";
            current_frame = "*";
          };

          controls = {
            icons = {
              pause = "⏸";
              play = "▶";
              step_into = "⏎";
              step_over = "⏭";
              step_out = "⏮";
              step_back = "b";
              run_last = "▶▶";
              terminate = "⏹";
              disconnect = "⏏";
            };
          };
        };
      };
      which-key.settings.spec = [
        {
          __unkeyed-1 = "<leader>d";
          mode = [
            "n"
            "v"
          ];
          group = "+debug";
        }
      ];
    };

    # https://nix-community.github.io/nixvim/keymaps/index.html
    keymaps = [
      {
        mode = [ "n" ];
        action = ":DapContinue<cr>";
        key = "<leader>dc";
        options = {
          desc = "Continue";
        };
      }
      {
        mode = [ "n" ];
        action = ":DapStepOver<cr>";
        key = "<leader>dO";
        options = {
          desc = "Step over";
        };
      }
      {
        mode = [ "n" ];
        action = ":DapStepInto<cr>";
        key = "<leader>di";
        options = {
          desc = "Step Into";
        };
      }
      {
        mode = [ "n" ];
        action = ":DapStepOut<cr>";
        key = "<leader>do";
        options = {
          desc = "Step Out";
        };
      }
      {
        mode = [ "n" ];
        action = "<cmd>lua require('dap').pause()<cr>";
        key = "<leader>dp";
        options = {
          desc = "Pause";
        };
      }
      {
        mode = [ "n" ];
        action = ":DapToggleBreakpoint<cr>";
        key = "<leader>db";
        options = {
          desc = "Toggle Breakpoint";
        };
      }
      {
        mode = [ "n" ];
        action = "<cmd>lua require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))<cr>";
        key = "<leader>dB";
        options = {
          desc = "Breakpoint (conditional)";
        };
      }
      {
        mode = [ "n" ];
        action = ":DapToggleRepl<cr>";
        key = "<leader>dR";
        options = {
          desc = "Toggle REPL";
        };
      }
      {
        mode = [ "n" ];
        action = "<cmd>lua require('dap').run_last()<cr>";
        key = "<leader>dr";
        options = {
          desc = "Run Last";
        };
      }
      {
        mode = [ "n" ];
        action = "<cmd>lua require('dap').session()<cr>";
        key = "<leader>ds";
        options = {
          desc = "Session";
        };
      }
      {
        mode = [ "n" ];
        action = ":DapTerminate<cr>";
        key = "<leader>dt";
        options = {
          desc = "Terminate";
        };
      }
      {
        mode = [ "n" ];
        action = "<cmd>lua require('dap.ui.widgets').hover()<cr>";
        key = "<leader>dw";
        options = {
          desc = "Hover Widget";
        };
      }
      {
        mode = [ "n" ];
        action = "<cmd>lua require('dapui').toggle()<cr>";
        key = "<leader>du";
        options = {
          desc = "Toggle UI";
        };
      }
      {
        mode = [ "n" ];
        action = "<cmd>lua require('dapui').eval()<cr>";
        key = "<leader>de";
        options = {
          desc = "Eval";
        };
      }
    ];
    # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=extraconfiglua#extraconfiglua
    extraConfigLua = ''
      require('dap').listeners.after.event_initialized['dapui_config'] = require('dapui').open
      require('dap').listeners.before.event_terminated['dapui_config'] = require('dapui').close
      require('dap').listeners.before.event_exited['dapui_config'] = require('dapui').close
    '';
  };
}
