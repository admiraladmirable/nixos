{ config, lib, ... }:
with lib;
{
  options.coolercontrol.enable = mkEnableOption "Enable Cooler Control service";

  config = mkIf config.coolercontrol.enable {
    programs.coolercontrol = {
      enable = true;
    };
  };
}
