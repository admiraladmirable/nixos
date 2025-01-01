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
