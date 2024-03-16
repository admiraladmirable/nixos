{
  config,
  lib,
  ...
}:
with lib;
{
  options.xorg.enable = mkEnableOption "Enable Xorg stack";

  config = mkIf config.xorg.enable {
    services.xserver.enable = true;
  };
}
