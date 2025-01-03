{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;

      settings = {
        open_mapping = "[[<c-\\>]]";
        insert_mappings = true;
        terminal_mappings = true;
      };
    };
  };
}
