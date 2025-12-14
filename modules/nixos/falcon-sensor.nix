{
  config,
  lib,
  inputs,
  ...
}:
with lib;
{
  imports = [
    inputs.self.nixosModules.falcon-sensor
  ];
  options.falcon-sensor.enable = mkEnableOption "Enable falcon-sensor service";

  config = mkIf config.falcon-sensor.enable {
    services.falcon-sensor = {
      enable = true;
    };
  };
}
