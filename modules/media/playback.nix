{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        ffmpeg-full
        libavif
        mpv
        gst_all_1.gstreamer
      ];
    };
}
