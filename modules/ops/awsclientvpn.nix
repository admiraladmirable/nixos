{ inputs, ... }:
{
  flake.modules.nixos.awsclientvpn = {
    imports = [ inputs.awsvpnclient.nixosModules.default ];
    programs.awsvpnclient.enable = true;
  };
}
