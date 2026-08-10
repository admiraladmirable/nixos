{ ... }:
{
  flake.modules.nixos.base =
    { lib, pkgs, ... }:
    {
      options.rmrf.cuda.enable = lib.mkEnableOption "CUDA acceleration for explicitly opted-in packages";

      config = {
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
    };
}
