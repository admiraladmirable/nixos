{ ... }:
{
  flake.modules.nixos.printing =
    { pkgs, lib, ... }:
    {
      services.printing = {
        enable = lib.mkDefault true;
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

  flake.modules.homeManager.printing =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        hplipWithPlugin
        sane-airscan
        sane-frontends
      ];
    };
}
