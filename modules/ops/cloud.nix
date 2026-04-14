{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        terraform
        terragrunt
        opentofu
        awscli2
        yq-go
      ];
    };
}
