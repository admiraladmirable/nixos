{ config, lib, ... }:
with lib;
{
  options.gpg.enable = mkEnableOption "Enable gnupg with agent";

  config = mkIf config.gpg.enable {
    programs.gnupg = {
      agent.enable = true;
    };
  };
}
