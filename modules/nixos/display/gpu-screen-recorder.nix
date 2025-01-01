
{ lib, config, ... }:
with lib;
{
  options.gpu-screen-recorder.enable = mkEnableOption "Enable GPU Screen Recorder (Shadowplay)";

  config = mkIf config.gpu-screen-recorder.enable {
    programs.gpu-screen-recorder.enable = true;
  };
}
