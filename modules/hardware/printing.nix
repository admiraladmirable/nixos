{ ... }:
{
  flake.modules.nixos.desktop =
    { pkgs, ... }:
    {
      services.printing = {
        enable = true;
        drivers = with pkgs; [
          hplipWithPlugin
          cups-filters
          cups-browsed
        ];
      };

      hardware.sane = {
        enable = true;
        extraBackends = [ pkgs.sane-airscan ];
      };

      services.ipp-usb.enable = true;
      services.avahi = {
        enable = true;
        nssmdns4 = true;
      };
    };

  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        hplipWithPlugin
        sane-airscan
        sane-frontends
      ];
    };
}
