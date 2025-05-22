{ config, lib, ... }:
with lib;
{
  options.musnix.enable = mkEnableOption "Enable Musnix";

  config = mkIf config.musnix.enable {
    musnix = {
      enable = true;
      rtcqs.enable = true;
      soundcardPciId = "2f:00.4";
    };
  };
}
