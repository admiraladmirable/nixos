{
  programs.nixvim = {
    plugins.lazygit = {
      enable = true;
    };

    keymaps = [
      {
        mode = [
          "n"
        ];
        key = "<leader>gg";
        action = ":LazyGit<cr>";
        options = {
          desc = "Lazygit Root Dir";
        };
      }
      # {
      #   mode = "n";
      #   key = "<leader>gf";
      #   action = "Snacks.picker.git_log_file()";
      #   options = {
      #     desc = "Git Current File History";
      #   };
      # }
    ];
  };
}
