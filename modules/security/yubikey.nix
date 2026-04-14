{ ... }:
let
  workstationYubikey =
    { pkgs, ... }:
    {
      programs.yubikey-manager.enable = true;
      services.pcscd.enable = true;
      # Enable YubiKey support (udev rules)
      hardware.gpgSmartcards.enable = true;

      # For FIDO2/WebAuthn in browsers
      services.udev.packages = [ pkgs.yubikey-personalization ];

      security.pam.u2f = {
        enable = true;
        settings = {
          cue = true;
          interactive = true;
        };
      };

      security.pam.services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
    };
in
{
  flake.modules.nixos.yubikeyWorkstation = workstationYubikey;

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        yubikey-manager
        pam_u2f
      ];

      programs.gpg = {
        enable = true;
        scdaemonSettings = {
          disable-ccid = true;
        };
      };

      services.gpg-agent = {
        enable = true;
        pinentry.package = pkgs.pinentry-qt;
      };
    };
}
