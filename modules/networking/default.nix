{ ... }:
{
  flake.modules.nixos.base = {
    networking.networkmanager.enable = true;
  };

  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        netcat
        inetutils
        dnsutils
        ethtool
        bmon
        iptables
      ];
    };

  flake.modules.nixos.desktopNetworking = {
    networking.firewall = {
      enable = false;
      allowedTCPPorts = [
        57621
        1119
        54545
        54546
        54547
        54548
        54549
        28890
        28891
        28892
        28893
        28894
        6112
        6113
        6114
        6443
        10250
      ];
      allowedUDPPorts = [ 5353 ];
    };
  };
}
