{
  programs.nixvim = {
    plugins.trim = {
      enable = false;

      settings = {
        patterns = [ "[[%s/\\n\n\)\n\+/\1/]]" ];
        trim_last_line = false;
        highlight = false;
      };
    };
  };
}
