{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
{
  options.yubikey.enable = mkEnableOption "Enable yubikey various features";

  config = mkIf config.yubikey.enable {
    # Smartcard mode (CCID)
    services.pcscd.enable = true;

    # For GPG and SSH
    services.udev.packages = [ pkgs.yubikey-personalization ];
  };
}
