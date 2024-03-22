{ lib, config, nixpkgs-unstable, ... }:
with lib; {
  options.xrdp.enable = mkEnableOption "Enable xrdp";

  config = mkIf config.xrdp.enable {
    services.xrdp.enable = true;
    services.xrdp.defaultWindowManager = "startplasma-x11";
    services.xrdp.openFirewall = true;
    services.xrdp.audio.enable = true;
  };
}
