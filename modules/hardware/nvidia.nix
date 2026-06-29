{ ... }:
{
  flake.modules.nixos.nvidia =
    { config, pkgs, ... }:
    {
      hardware = {
        enableRedistributableFirmware = true;
      };
      hardware = {
        graphics = {
          extraPackages = with pkgs; [
            nvidia-vaapi-driver
          ];
        };
        nvidia = {
          modesetting.enable = true;
          powerManagement.enable = true;
          powerManagement.finegrained = false;
          nvidiaSettings = true;
          package = config.boot.kernelPackages.nvidiaPackages.production;
          open = true;
        };
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

      home-manager.sharedModules = [
        {
          home.sessionVariables = {
            LIBVA_DRIVER_NAME = "nvidia";
            __GLX_VENDOR_LIBRARY_NAME = "nvidia";
            GBM_BACKEND = "nvidia-drm";
            NVD_BACKEND = "direct";
            __GL_GSYNC_ALLOWED = "1";
            __GL_VRR_ALLOWED = "1";
          };

          programs.obs-studio.package = pkgs.obs-studio.override { cudaSupport = true; };
        }
      ];
    };
}
