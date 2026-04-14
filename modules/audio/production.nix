{ ... }:
{
  flake.modules.homeManager.audioProduction =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        vcv-rack-custom
        (cardinal.override { libjack2 = pkgs.pipewire.jack; })
        qpwgraph
        reaper
      ];
    };
}
