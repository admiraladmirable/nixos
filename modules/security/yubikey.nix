{ ... }:
let
  workstationYubikey = {
    programs.yubikey-manager.enable = true;
    services.pcscd.enable = true;
    # Enable YubiKey support (udev rules)
    hardware.gpgSmartcards.enable = true;

    # For FIDO2/WebAuthn in Firefox
    # services.udev.packages = [ pkgs.yubikey-personalization ];

    # environment.systemPackages = with pkgs; [
    #   yubikey-manager # ykman CLI tool
    #   pam_u2f # For system login
    # ];

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
  flake.modules.nixos.desktop = workstationYubikey;
  flake.modules.nixos.work = workstationYubikey;

  flake.modules.homeManager.workstation =
    { pkgs, ... }:
    {
      programs.gpg = {
        enable = true;
        scdaemonSettings = {
          disable-ccid = true;
        };
      };

      services.gpg-agent = {
        enable = true;
        pinentry.package = pkgs.pinentry-curses;
      };
    };
}
