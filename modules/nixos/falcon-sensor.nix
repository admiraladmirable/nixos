{ ... }:
{
  # Thin wrapper to make the falcon-sensor service module part of the shared module set.
  imports = [
    ../pkgs/falcon-sensor
  ];
}
