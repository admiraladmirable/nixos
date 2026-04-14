{ inputs, ... }:
{
  flake.modules.homeManager.base = {
    imports = [ inputs.lan-mouse.homeManagerModules.default ];

    programs.lan-mouse = {
      enable = true;
      systemd = false;
    };
  };
}
