(builtins.concatStringsSep "\n") (map (x: "luafile ${x}") [
  ./options.lua
  ./keymaps.lua
  ./lsp.lua
  ./cmp.lua
  ./colorschemes.lua
  ./treesitter.lua
])
