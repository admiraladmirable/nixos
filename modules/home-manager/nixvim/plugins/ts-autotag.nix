{
  programs.nixvim = {
    plugins.ts-autotag = {
      enable = true;
    };
    plugins.ts-context-commentstring = {
      enable = true;
    };
  };
}
