{ ... }:
{
  flake.modules.nixos.framework16 =
    { pkgs, ... }:
    {
      services.fprintd.enable = true;

      hardware = {
        sensor.iio.enable = true;
        keyboard.qmk.enable = true;
      };

      environment.systemPackages = with pkgs; [ framework-tool ];
    };
}
