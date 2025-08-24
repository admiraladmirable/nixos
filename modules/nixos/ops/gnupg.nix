{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  options.gpg.enable = mkEnableOption "Enable gnupg with agent";

  config = mkIf config.gpg.enable {
    services.udev.packages = [ pkgs.yubikey-personalization ];
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
}
