{
  programs.nixvim = {
    keymaps = [
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<CR>";
      }
      {
        key = "<leader>e";
        mode = "n";
        action = "<cmd>NvimTreeToggle<cr>";
        options = {
          desc = "NvimTreeToggle";
        };
      }
      {
        key = "<leader>;";
        mode = "n";
        action = "<cmd>Alpha<cr>";
        options = {
          desc = "Dashboard";
        };
      }
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<CR>";
      }
      {
        mode = "n";
        key = "<leader>xX";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
      }
      {
        mode = "n";
        key = "<leader>cs";
        action = "<cmd>Trouble symbols toggle focus=false<CR>";
      }
      {
        mode = "n";
        key = "<leader>cl";
        action = "<cmd>Trouble lsp toggle focus=false win.position=right<CR>";
      }
      {
        mode = "n";
        key = "<leader>xL";
        action = "<cmd>Trouble loclist toggle<CR>";
      }
      {
        mode = "n";
        key = "<leader>xQ";
        action = "<cmd>Trouble qflist toggle<CR>";
      }

      # {
      #   key = "[[<c-\>]]";
      #   mode = "n";
      #   action = "<cmd>ToggleTerm<cr>";
      #   options = {
      #     desc = "Toggle Terminal";
      #   };
      # }
    ];
  };
}
