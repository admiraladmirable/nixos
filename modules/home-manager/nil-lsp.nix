{ pkgs, inputs, ... }: {
  imports = [ inputs.nil-lsp.homeManagerModules.default ];
}
