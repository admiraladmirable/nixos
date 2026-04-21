{
  inputs,
  lib,
  config,
  ...
}:
{
  config.flake.modules.homeManager.hyprland =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.noctalia.homeModules.default ];

      config = lib.mkIf (config.desktop.shell == "noctalia") {
        programs.noctalia-shell = {
          enable = true;
          package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
          # systemd.enable = true;
          settings = lib.mkForce (builtins.fromJSON (builtins.readFile ./noctalia.json));
        };
      };
    };
}
