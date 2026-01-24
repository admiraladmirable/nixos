{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  options.awsclientvpn.enable = mkEnableOption "Enable awsclientvpn";

  config = mkIf config.awsclientvpn.enable {
    programs.awsvpnclient.enable = true;
  };
}
