{ ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      programs.gpu-screen-recorder.enable = true;
      hardware = {
        graphics = {
          enable = true;
          enable32Bit = true;
          # extraPackages = with pkgs; [
          #   nvidia-vaapi-driver
          # ];
        };
        enableRedistributableFirmware = true;
      };
    };
}
