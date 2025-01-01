{
  programs.nixvim.plugins = {
    lsp = {
      enable = true;
      inlayHints = true;

      servers = {
        lua_ls = {
          enable = true;
          settings.telemetry.enable = false;
        };

        bashls.enable = true;
        dartls.enable = true;
        cmake.enable = true;
        dockerls.enable = true;
        docker_compose_language_service.enable = true;
        helm_ls.enable = true;
        jsonls.enable = true;
        nixd.enable = true;
        tflint.enable = true;
        yamlls.enable = true;

        html.enable = true;
        htmx.enable = true;
        ts_ls.enable = true;
        ts_query_ls.enable = true;
        eslint.enable = true;

        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
      };
    };
  };
}
