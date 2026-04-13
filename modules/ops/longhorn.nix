{ ... }:
{
  flake.modules.nixos.longhorn = {
    systemd.tmpfiles.rules = [
      "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
    ];

    services.openiscsi = {
      enable = true;
      name = "iqn.2020-08.org.linux-iscsi.initiatorhost:homelab-1";
    };
  };
}
