{ ... }:
{
  flake.modules.nixos.polkitAgent =
    { pkgs, ... }:
    {
      security.polkit.enable = true;

      systemd.user.services.polkit-kde-agent = {
        description = "KDE polkit authentication agent";
        wantedBy = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
          Restart = "on-failure";
        };
      };
    };
}
