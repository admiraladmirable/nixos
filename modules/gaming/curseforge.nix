{ inputs, ... }:
{
  flake.modules.nixos.curseforge = {
    imports = [ inputs.curseforge.nixosModules.default ];
    programs.curseforge.enable = true;
  };
}
