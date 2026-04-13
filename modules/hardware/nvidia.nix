{ ... }:
{
  flake.modules.nixos.desktop =
    { config, pkgs, ... }:
    {
      hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.beta;
        open = true;
      };

      services.xserver.videoDrivers = [ "nvidia" ];

      environment.variables = {
        NIXOS_OZONE_WL = "1";
        MOZ_USE_XINPUT2 = "1";
        MOZ_DISABLE_RDD_SANDBOX = "1";
        NVD_BACKEND = "direct";
        GBM_BACKEND = "nvidia-drm";
        __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      };
    };
}
