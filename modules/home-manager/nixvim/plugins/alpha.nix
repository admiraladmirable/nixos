{
  programs.nixvim = {
    plugins.alpha = {
      enable = true;
      layout = [
        {
          type = "padding";
          val = 2;
        }
        {
          type = "text";
          val = [
            ''░▒▓███████▓▒░░▒▓██████████████▓▒░░▒▓███████▓▒░░▒▓████████▓▒░ ''
            ''░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        ''
            ''░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        ''
            ''░▒▓███████▓▒░░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓███████▓▒░░▒▓██████▓▒░   ''
            ''░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        ''
            ''░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        ''
            ''░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░░▒▓█▓▒░▒▓█▓▒░        ''
            ];
          opts = {
            position = "center";
            hl = "@comment";
          };
        }
        {
          type = "padding";
          val = 2;
        }
        {
          type = "group";
          val = [
            {
              type = "button";
              val = " Find File";
              on_press.__raw = "function() vim.cmd[[Telescope find_files]] end";
              opts = {
                shortcut = "sf";
                position = "center";
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "padding";
              val = 2;
            }
            {
              type = "button";
              val = " New File";
              on_press.__raw = "function() vim.cmd[[ene]] end";
              opts = {
                shortcut = "n";
                position = "center";
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "padding";
              val = 2;
            }
            {
              type = "button";
              val = " Projects";
              on_press.__raw = "function() vim.cmd[[qa]] end";
              opts = {
                shortcut = "p";
                position = "center";
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "padding";
              val = 2;
            }
            {
              type = "button";
              val = " Recent Files";
              on_press.__raw = "function() vim.cmd[[qa]] end";
              opts = {
                shortcut = "r";
                position = "center";
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "padding";
              val = 2;
            }
            {
              type = "button";
              val = " Find Text";
              on_press.raw = "require('telescope.builtin').live_grep";

              opts = {
                keymap = ["n" "t" ":Telescope live_grep <CR>" {noremap = true; silent = true; nowait = true;}];
                shortcut = "sg";
                position = "center";
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
            {
              type = "padding";
              val = 2;
            }
            {
              type = "button";
              val = " Quit";
              on_press.__raw = "function() vim.cmd[[qa]] end";
              opts = {
                keymap = ["n" "q" ":qa<CR>" {noremap = true; silent = true; nowait = true;}];
                shortcut = "q";
                position = "center";
                cursor = 3;
                width = 50;
                align_shortcut = "right";
                hl_shortcut = "Keyword";
              };
            }
          ];
        }
        {
          type = "padding";
          val = 2;
        }
        {
          type = "text";
          val = "Inspiring quote here.";
          opts = {
            position = "center";
            hl = "Keyword";
          };
        }
      ];
    };
  };
}
