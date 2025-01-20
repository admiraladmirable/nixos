{
  programs.nixvim = {
    autoCmd = [
      {
        event = [
          "BufEnter"
          "BufNew"
        ];
        desc = "disable statuscolumn for neo-tree and dashboard";
        callback.__raw = ''
          function()
            local ft_ignore = { "dashboard", "neo-tree" }
            if vim.tbl_contains(ft_ignore, vim.bo.filetype) then
              vim.cmd("setlocal foldcolumn=0")
            end
          end
        '';
      }
    ];

    plugins = {
      statuscol = {
        enable = true;
        settings = {
          relculright = true;
          ft_ignore = [
            "dashboard"
            "neo-tree"
          ];
          segments = [
            {
              click = "v:lua.ScFa";
              text = [ "%C" ];
            }
            {
              click = "v:lua.ScSa";
              text = [ " %s" ];
            }
            {
              click = "v:lua.ScLa";
              text = [
                { __raw = "require('statuscol.builtin').lnumfunc"; }
                " "
              ];
            }
          ];
        };
      };

      nvim-ufo = {
        enable = true;
        settings = {
          provider_selector = # lua
            ''
              function()
                return { "lsp", "indent" }
              end
            '';
          preview.mappings = {
            close = "q";
            switch = "K";
          };
        };
      };
    };

    opts = {
      foldcolumn = "1";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;
      fillchars.__raw = "[[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]";
    };

    keymaps = [
      {
        mode = "n";
        key = "zR";
        action.__raw = "function() require('ufo').openAllFolds() end";
        options.desc = "open all folds";
      }
      {
        mode = "n";
        key = "zM";
        action.__raw = "function() require('ufo').closeAllFolds() end";
        options.desc = "close all folds";
      }
      {
        mode = "n";
        key = "zK";
        action.__raw = "function() local winid = require('ufo').peekFoldedLinesUnderCursor() if not winid then vim.lsp.buf.hover() end end";
        options.desc = "Peek Folded Lines";
      }
    ];
  };
}
