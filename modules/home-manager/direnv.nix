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
        KUBECONFIG = "/etc/rancher/k3s/k3s.yaml";
        EDITOR = "nvim";
        KUBE_EDITOR = "nvim";
      };

      shellAliases = {
        k = "kubectl";
      };
    };
  };
}
