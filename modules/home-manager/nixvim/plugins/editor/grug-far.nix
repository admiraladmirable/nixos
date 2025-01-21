{
  programs.nixvim = {
    plugins.grug-far = {
      enable = true;
    };
    keymaps = [
      {
        mode = [
          "n"
          "v"
        ];
        key = "sr";
        action = ":GrugFar<cr>";
        options.desc = "Search and Replace";
      }
    ];
  };
}
