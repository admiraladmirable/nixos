{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        kubectl
        kubectx
        kubernetes-helm
        cilium-cli
        hubble
      ];
    };
}
