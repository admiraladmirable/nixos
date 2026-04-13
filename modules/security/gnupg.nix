{ ... }:
{
  flake.modules.nixos.base = {
    programs.gnupg.agent.enable = true;
  };
}
