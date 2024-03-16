{ pkgs, inputs, ... }:

{
  programs.firefox = {
    
    enable = true;
    package = pkgs.firefox-esr;

    profiles.senoraraton = {

      search.force = true;

      settings = {
        "browser.download.panel.shown" = true;
        "identity.fxaccounts.enabled" = false;
        "signon.rememberSignons" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "extensions.autoDisableScopes" = 0;
        "extensions.enabledScopes" = 15;
        "xpinstall.signatures.required" = false;
        "browser.toolbars.bookmarks.visibility" = "never";

        "browser.startup.homepage" = "chrome://browser/content/blanktab.html";
        "browser.newtabpage.activity-stream.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.newtabpage.activity-stream.discoverystream.sendToPocket.enabled" = false;
        "extensions.pocket.enabled" = false;
        "extensions.pocket.showHome" = false;
        "browser.onboarding.enabled" = false;
        #"image.webp.enabled" = false;
      };

      userChrome = ''                         
      #TabsToolbar {visibility: collapse;}
      :root{
        --uc-autohide-toolbox-delay: 200ms; /* Wait 0.1s before hiding toolbars */
        --uc-toolbox-rotation: 82deg;  /* This may need to be lower on mac - like 75 or so */
      }

      :root[sizemode="maximized"]{
        --uc-toolbox-rotation: 88.5deg;
      }

      @media  (-moz-platform: windows){
        #navigator-toolbox:not(:-moz-lwtheme){ background-color: -moz-dialog !important; }
      }

      :root[sizemode="fullscreen"],
      #navigator-toolbox[inFullscreen]{ margin-top: 0 !important; }

      #navigator-toolbox{
        position: fixed !important;
        display: block;
        background-color: var(--lwt-accent-color,black) !important;
        transition: transform 82ms linear, opacity 82ms linear !important;
        transition-delay: var(--uc-autohide-toolbox-delay) !important;
        transform-origin: top;
        transform: rotateX(var(--uc-toolbox-rotation));
        opacity: 0;
        line-height: 0;
        z-index: 1;
        pointer-events: none;
      }

      /* #mainPopupSet:hover ~ toolbox, */
      /* Uncomment the above line to make toolbar visible if some popup is hovered */
      #navigator-toolbox:hover,
      #navigator-toolbox:focus-within{
        transition-delay: 33ms !important;
        transform: rotateX(0);
        opacity: 1;
      }

      #navigator-toolbox > *{ line-height: normal; pointer-events: auto }

      #navigator-toolbox,
      #navigator-toolbox > *{
        width: 100vw;
        -moz-appearance: none !important;
      }

      /* These two exist for oneliner compatibility */
      #nav-bar{ width: var(--uc-navigationbar-width,100vw) }
      #TabsToolbar{ width: calc(100vw - var(--uc-navigationbar-width,0px)) }

      /* Don't apply transform before window has been fully created */
      :root:not([sessionrestored]) #navigator-toolbox{ transform:none !important }

      :root[customizing] #navigator-toolbox{
        position: relative !important;
        transform: none !important;
        opacity: 1 !important;
      }

      #navigator-toolbox[inFullscreen] > #PersonalToolbar,
      #PersonalToolbar[collapsed="true"]{ display: none }

      /* Uncomment this if tabs toolbar is hidden with hide_tabs_toolbar.css */
       /*#titlebar{ margin-bottom: -9px }*/

      /* Uncomment the following for compatibility with tabs_on_bottom.css - this isn't well tested though */
      /*
      #navigator-toolbox{ flex-direction: column; display: flex; }
      #titlebar{ order: 2 }
      */

      #sidebar-header {
        display: none;
      }
      #sidebar-splitter {
        display:none;
      }
      '';                                      

      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        ublock-origin
        darkreader
        sponsorblock
        youtube-nonstop
        youtube-shorts-block
        return-youtube-dislikes
        tridactyl
        ff2mpv
        auto-tab-discard
        bitwarden
        export-tabs-urls-and-titles
        istilldontcareaboutcookies
        torrent-control
        unpaywall
        (sidebery.override { url = "https://addons.mozilla.org/firefox/downloads/file/4170134/sidebery-5.0.0.xpi"; sha256 = "f592427a1c68d3e51aee208d05588f39702496957771fd84b76a93e364138bf5"; })
      ] ;
      search.engines = {
        "Nix Packages" = {
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
              { name = "type"; value = "packages"; }
              { name = "query"; value = "{searchTerms}"; }
            ];
          }];

          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@np" ];
        };
      };
    };
  };
}
