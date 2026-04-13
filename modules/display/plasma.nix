{ ... }:
{
  flake.modules.nixos.plasma = {
    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    services.desktopManager.plasma6.enable = true;
  };
}
