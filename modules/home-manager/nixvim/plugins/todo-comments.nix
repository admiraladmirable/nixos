{
  programs.nixvim = {
    plugins.todo-comments = {
        enable = true;
        settings = {
          signs = true;
        };
      };
  };
}
