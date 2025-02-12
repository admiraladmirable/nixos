{
  programs.nixvim = {
    plugins.notify = {
      enable = true;
      settings = {
        timeout = 1;
        # fps = 144;
      };
    };
  };
}
