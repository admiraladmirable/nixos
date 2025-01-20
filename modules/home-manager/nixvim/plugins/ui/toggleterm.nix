{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;

      settings = {
        size = ''
          function(term)
            if term.direction == "horizontal" then
              return 30
          elseif term.direction == "vertical" then
              return vim.o.columns * 0.4
            end
          end
        '';
        open_mapping = "[[<c-\\>]]";
        insert_mappings = true;
        terminal_mappings = true;
      };
    };

    keymaps = [
      {
        mode = "t";
        key = "<C-g>";
        action = "<cmd>2ToggleTerm<cr>";
        options.desc = "Open/Close Terminal 2";
      }
      {
        mode = "t";
        key = "<C-Left>";
        action = "<cmd>wincmd h<cr>";
        options.desc = "Go to Left window";
      }
      {
        mode = "t";
        key = "<C-Right>";
        action = "<cmd>wincmd l<cr>";
        options.desc = "Go to Right window";
      }
      {
        mode = "t";
        key = "<C-Up>";
        action = "<cmd>wincmd k<cr>";
        options.desc = "Go to Up window";
      }
      {
        mode = "t";
        key = "<C-Down>";
        action = "<cmd>wincmd j<cr>";
        options.desc = "Go to Down window";
      }
    ];
  };
}
