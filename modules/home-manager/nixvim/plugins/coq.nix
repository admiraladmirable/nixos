{
  programs.nixvim = {
    plugins.coq-nvim = {
      enable = false;
      installArtifacts = true;

      settings = {
        auto_start = true;
        completion.always = true;
      };
    };
  };
}
