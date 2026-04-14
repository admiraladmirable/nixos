{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        kubectl
        kubernetes-helm
        cilium-cli
        hubble
      ];
    };
}
