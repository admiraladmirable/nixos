{
  programs.nixvim = {
    plugins.mini = {
      enable = true;

      modules = {
        animate = {
          cursor = {
            enable = true;
          };
          scroll = {
            enable = true;
          };
          resize = {
            enable = true;
          };
          open = {
            enable = true;
          };
          close = {
            enable = true;
          };
        };
      };
    };
  };
}
