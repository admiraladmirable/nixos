{ ... }:
{
  flake.modules.nixos.pipewire = {
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      jack.enable = true;
    };
  };

  flake.modules.homeManager.easyeffects = {
    services.easyeffects.enable = true;
  };
}
