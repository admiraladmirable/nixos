{ pkgs, inputs, ... }:
{
  programs.firefox = {
    enable = true;

    profiles = {
      rmrf-work = {
        id = 1;
      };

      rmrf = {
        id = 0;
        search.force = true;

        settings = {
          "widget.use-xdg-desktop-portal.file-picker" = 1;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.rdd-ffmpeg.enabled" = true;
          "media.avi.enabled" = true;
          "widget.dmabuf.force-enabled" = true;
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
}
