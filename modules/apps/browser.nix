{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, config, ... }:
    {
      home.packages = with pkgs; [
        brave
        chromium
      ];

      programs.firefox = {
        enable = true;
        # nixpkgs' firefox wrapper hardcodes MOZ_LEGACY_PROFILES=1, which forces
        # the profile root to ~/.mozilla/firefox regardless of XDG. home-manager's
        # configPath only moves the managed files (profiles.ini etc.), so pointing
        # it at the XDG dir desyncs from where firefox actually reads and loses the
        # profile. Pin to the legacy path to match the wrapper (also silences the
        # 26.05 default-change warning).
        configPath = ".mozilla/firefox";

        profiles = {
          rmrf-work.id = 1;

          rmrf = {
            id = 0;
            search.force = true;

            settings = {
              "widget.use-xdg-desktop-portal.file-picker" = 1;
              "media.ffmpeg.vaapi.enabled" = true;
              "media.rdd-ffmpeg.enabled" = true;
              "media.avi.enabled" = true;
              "widget.dmabuf.force-enabled" = true;
              "media.hardware-video-decoding.force-enabled" = true;
            };

            search.engines = {
              "Nix Packages" = {
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [
                      {
                        name = "type";
                        value = "packages";
                      }
                      {
                        name = "query";
                        value = "{searchTerms}";
                      }
                    ];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@np" ];
              };
            };
          };
        };
      };
    };
}
