{ ... }:
{
  flake.modules.homeManager.openmw =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        openmw
        tes3cmd
        groundcoverify
        s3lightfixes
        pkgs."delta-plugin"
        pkgs."momw-configurator"
        pkgs."openmw-validator"
        umo
      ];
    };
}
