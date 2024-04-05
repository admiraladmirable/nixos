{ pkgs, inputs, ... }:
{
  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    bash = {
      enable = true;
      sessionVariables = {
        PROMPT_COMMAND = "history -a; $PROMPT_COMMAND";
        EDITOR = "nvim";
        KUBE_EDITOR = "nvim";
      };
    };
  };
}
