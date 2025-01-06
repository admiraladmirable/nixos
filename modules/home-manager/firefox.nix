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

        extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
          ublock-origin
          darkreader
          sponsorblock
          youtube-nonstop
          return-youtube-dislikes
          tridactyl
          ff2mpv
          bitwarden
          export-tabs-urls-and-titles
          istilldontcareaboutcookies
          unpaywall
          (sidebery.override {
            url = "https://addons.mozilla.org/firefox/downloads/file/4170134/sidebery-5.0.0.xpi";
            sha256 = "f592427a1c68d3e51aee208d05588f39702496957771fd84b76a93e364138bf5";
          })
        ];
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
