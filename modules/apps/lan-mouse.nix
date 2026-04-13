{ inputs, ... }:
{
  flake.modules.homeManager.workstation = {
    imports = [ inputs.lan-mouse.homeManagerModules.default ];

    programs.lan-mouse = {
      enable = true;
      systemd = false;
    };
  };
}
