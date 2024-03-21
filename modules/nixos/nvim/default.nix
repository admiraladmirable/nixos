{
  pkgs,
  lib,
  ...
}: let
  myNeovim = let
    neovimConfig = pkgs.neovimUtils.makeNeovimConfig {
      plugins =
        [pkgs.vimPlugins.nvim-treesitter.withAllGrammars]
        ++ lib.mapAttrsToList (
          pname: v: (pkgs.vimUtils.buildVimPlugin {
            inherit pname;
            version = builtins.substring 0 8 v.revision;
            src = builtins.fetchTarball {
              inherit (v) url;
              sha256 = v.hash;
            };
          })
        )
        (lib.filterAttrs (name: _:
          builtins.elem name [
            "nvim-lspconfig"
            "go.nvim"
            "guihua.lua"
            "vim-floaterm"
            "popup"
            "plenary.nvim"
            "undotree"
            "telescope.nvim"
            "nvim-treesitter-textojbects"
            "playground"
            "lualine.nvim"
            "nvim-web-devicons"
            "vim-nix"
            "cmp-nvim-lsp"
            "cmp-buffer"
            "cmp-path"
            "cmp-cmdline"
            "cmp-nvim-lua"
            "nvim-cmp"
            "telescope-fzf-native.nvim"
            "emmet-vim"
            "tokyonight.nvim"
            "neovim"
            "vim-dogrun"
            "space-vim-theme"
            "leaf.nvim"
            "nvim-dap"
            "one-small-step-for-vimkind"
            "nvim-dap-ui"
            "nvim-dap-virtual-text"
            "vim-closetag"
            "null-ls.nvim"
            "nerdcommenter"
            "vim-fugitive"
            "prettier.nvim"
            "nvim-ts-rainbow"
            "vim-startuptime"
            "cmp_luasnip"
            "LuaSnip"
            "neomake"
            "prettier.nvim"
            #Fennel/Clojure conf
            #"conjure"
            #"vim-jack-in"
            #"vim-dispatch"
            #"vim-dispatch-neovim"
            #"cmp-conjure"
          ]) (import ../../../npins));
      withPython3 = true;
      extraPython3Packages = _: [];
      viAlias = false;
      vimAlias = false;
      customRC = import ./lua;
    };
    wrapperArgs = let
      path = lib.makeBinPath (
        with pkgs; [
          #Nix
          deadnix
          statix
          alejandra

          #Lua
          lua-language-server
          stylua
          luajitPackages.luacheck

          #Typescript
          nodePackages_latest.typescript-language-server
          nodePackages_latest.prettier

          #Go
          gopls
          gofumpt
          gotools
          go-outline
          gopls
          gopkgs
          godef
          golint
          delve
          ginkgo
          richgo
          gotestsum
          #C
          clang
          clang-tools
          cpplint
          cppcheck
          checkmake
          vscode-extensions.ms-vscode.cpptools
          #Ops
          ansible-language-server
          hadolint
          yamllint
          terraform-ls
          tflint
          vimPlugins.gentoo-syntax
          vim-vint
          shellcheck
          nodePackages_latest.jsonlint
          dotenv-linter
          sqls

          #Frontend
          vscode-langservers-extracted
        ]
      );
    in
      neovimConfig.wrapperArgs
      ++ [
        "--prefix"
        "PATH"
        ":"
        path
        "--prefix"
        "LUA_PATH"
        ";"
        "${./lua}/?.lua"
      ];
  in
    pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped (neovimConfig // {inherit wrapperArgs;});
in {
  environment.systemPackages = [myNeovim];
}
