{ config, lib, ... }:
with lib; {
  options.deluge.enable = mkEnableOption "Enable deluge service";

  config = mkIf config.deluge.enable {
    services.deluge = {
      enable = true;
      openFirewall = true;
      web = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
