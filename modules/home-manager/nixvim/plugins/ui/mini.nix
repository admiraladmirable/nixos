{
  programs.nixvim = {
    plugins.mini = {
      enable = true;

      modules = {
        animate = {
          cursor = {
            enable = true;
            # timing.__raw = ''
            #   function()
            #     animate.gen_timing.linear({ duration = 50, unit = "total "})
            #   end
            # '';
            # path.__raw = ''
            #   function()
            #     animate.gen_timing.linear({ duration = 150, unit = "total "})
            #   end
            # '';
          };
          scroll = {
            enable = true;
            # timing.__raw = ''
            #   function()
            #     animate.gen_timing.linear({ duration = 50, unit = "total"})
            #   end
            # '';
            # subscroll.__raw = ''
            #   function()
            #     animate.gen_timing.linear({ duration = 150, unit = "total"})
            #   end
            # '';
          };
          resize = {
            enable = true;
            # timing.__raw = ''
            #   function()
            #     animate.gen_timing.linear({ duration = 50, unit = "total"})
            #   end
            # '';
            # subresize.__raw = ''
            #   function()
            #     animate.gen_timing.linear({ duration = 150, unit = "total"})
            #   end
            # '';
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
