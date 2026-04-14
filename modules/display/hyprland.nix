{ inputs, config, ... }:
{
  flake.modules.nixos.hyprland =
    { pkgs, ... }:
    {
      programs = {
        uwsm.enable = true;
        hyprlock.enable = false;
        hyprland = {
          enable = true;
          withUWSM = true;
          systemd.setPath.enable = true;
          package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
          portalPackage =
            inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        };
      };

      services = {
        hypridle.enable = false;
        displayManager.sddm = {
          enable = true;
          wayland.enable = true;
          theme = "catppuccin-mocha-mauve";
          package = pkgs.kdePackages.sddm;
        };
      };

      xdg.portal = {
        enable = true;
        xdgOpenUsePortal = true;
        extraPortals = [
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
          pkgs.kdePackages.xdg-desktop-portal-kde
        ];
        configPackages = [
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland
        ];
        config.common = {
          default = [
            "hyprland"
            "kde"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
        };
      };

      environment.etc."xdg/menus/applications.menu".source =
        "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

      security.pam.services = {
        hyprlock = { };
        login.kwallet.enable = true;
        sddm.kwallet.enable = true;
      };

      environment.systemPackages = with pkgs; [
        (catppuccin-sddm.override {
          flavor = "mocha";
          font = "Noto Sans";
          fontSize = "9";
          loginBackground = true;
        })
        sddm-chili-theme
      ];

      home-manager.sharedModules = [ config.flake.modules.homeManager.hyprland ];
    };

  flake.modules.homeManager.hyprland =
    { pkgs, lib, config, ... }:
    let
      noctaliaPackage = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      caelestiaPackage = inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.caelestia-shell;
      noctaliaExe = lib.getExe noctaliaPackage;
      caelestiaExe = lib.getExe caelestiaPackage;
      noctaliaIpc = "${noctaliaExe} ipc call";
      launcherCommand =
        if config.desktop.shell == "noctalia" then
          "${noctaliaIpc} launcher toggle"
        else
          "rofi -show combi";
    in
    {
      xdg.configFile."uwsm/env".source =
        "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";

      home.packages =
        (with pkgs; [
        hyprcursor
        hyprutils
        hyprpicker
        hyprprop
        hyprshot
        grimblast
        brightnessctl
        playerctl
        xwayland
        wayland-protocols
        kdePackages.polkit-qt-1
        kdePackages.filelight
        kdePackages.kate
        kdePackages.gwenview
        kdePackages.ark
        kdePackages.kio
        kdePackages.kio-extras
        kdePackages.kservice
        kdePackages.breeze-icons
        desktop-file-utils
        gnome-menus
        shared-mime-info
        xdg-utils
        kdePackages.dolphin
        kdePackages.dolphin-plugins
        kdePackages.kdesdk-thumbnailers
        kdePackages.kdegraphics-thumbnailers
        kdePackages.kdegraphics-mobipocket
        kdePackages.kimageformats
        kdePackages.calligra
        kdePackages.qtimageformats
        kdePackages.ffmpegthumbs
        kdePackages.taglib
        kdePackages.baloo
        kdePackages.baloo-widgets
        kdePackages.qt6ct
        kdePackages.kwallet
        kdePackages.kwalletmanager
        catppuccin-qt5ct
        nwg-look
        dunst
        cliphist
        wl-clipboard
        inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default
        inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
        noctaliaPackage
        pkgs.hyprdim
        pkgs._1password-gui
      ])
        ++ lib.optionals (config.desktop.shell != "noctalia") [ pkgs.waybar ];

      gtk = {
        enable = true;
        gtk4.theme = config.gtk.theme;
        cursorTheme = {
          package = inputs.rose-pine-hyprcursor.packages.${pkgs.stdenv.hostPlatform.system}.default;
          name = "BreezeX-RosePine-Linux";
        };
        iconTheme = {
          name = "Papirus";
          package = pkgs.papirus-icon-theme;
        };
      };

      qt.enable = true;
      xdg.userDirs = {
        enable = true;
        setSessionVariables = true;
      };

      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        GDK_BACKEND = "wayland";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        HYPRCURSOR_THEME = "rose-pine-hyprcursor";
        HYPRCURSOR_SIZE = "36";
        XCURSOR_THEME = "BreezeX-RosePine-Linux";
        GSK_RENDERER = "ngl";
      };

      wayland.windowManager.hyprland = {
        enable = true;
        package = null;
        portalPackage = null;
        systemd.variables = [ "--all" ];
        systemd.enable = false;

        plugins = with inputs.hyprland-plugins.packages.${pkgs.stdenv.hostPlatform.system}; [
          borders-plus-plus
          hyprbars
        ];

        settings =
          {
            "$mod" = "SUPER";
            "$filemanager" = "dolphin";
            "$menu" = "rofi -show combi";

            exec-once = [
              "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init"
              "wl-paste --type text --watch cliphist store"
              "hyprdim"
              "udiskie"
              "${noctaliaExe}"
              "uwsm finalize"
            ];

            exec = [
              "swww img /home/rmrf/Pictures/_DSC0148.jpg -t random --transition-duration 2"
            ];

            cursor = {
              no_break_fs_vrr = 1;
              min_refresh_rate = 60;
            };

            input = {
              sensitivity = "0";
              accel_profile = "flat";
              force_no_accel = "1";
            };

            xwayland.force_zero_scaling = true;

            plugin = {
              borders-plus-plus = {
                add_borders = 1;
                natural_rounding = "yes";
              };
            };

            animations = {
              "enabled" = "yes";
              "bezier" = [
                "wind, 0.05, 0.9, 0.1, 1.05"
                "winIn, 0.1, 1.1, 0.1, 1.1"
                "winOut, 0.3, -0.3, 0, 1"
                "liner, 1, 1, 1, 1"
              ];
              "animation" = [
                "windows, 1, 6, wind, slide"
                "windowsIn, 1, 6, winIn, slide"
                "windowsOut, 1, 5, winOut, slide"
                "windowsMove, 1, 5, wind, slide"
                "border, 1, 1, liner"
                "borderangle, 1, 30, liner, once"
                "fade, 1, 10, default"
                "workspaces, 1, 5, wind"
              ];
            };

            dwindle = {
              "pseudotile" = "yes";
              "preserve_split" = "yes";
            };

            render = {
              direct_scanout = 1;
            };

            misc = {
              force_default_wallpaper = 0;
              vrr = 2;
            };

            decoration = {
              rounding = 10;
            };

            general = {
              resize_on_border = true;
              snap.enabled = true;
              allow_tearing = true;
            };

            bind =
              [
                "$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
                "$mod, T, exec, ghostty"
                "$mod, C, killactive"
                "$mod+Shift, C, forcekillactive"
                "$mod, E, exec, hyprctl keyword general:layout 'dwindle'"
                "$mod, F, fullscreen"
                "$mod, G, togglegroup"
                "$mod+Shift, G, moveoutofgroup"
                "$mod, P, exec, 1password --quick-access"
                "$mod+Shift, F, togglefloating"
                "$mod+Shift, R, exec, hyprctl reload"
                "$mod, Left, workspace, m-1"
                "$mod+Shift, Left, movetoworkspacesilent, m-1"
                "$mod, Right, workspace, m+1"
                "$mod+Shift, Right, movetoworkspacesilent, m+1"
                "$mod, Up, cyclenext, tiled"
                "$mod, Up, changegroupactive"
                "$mod+Shift, Up, swapnext, tiled"
                "$mod+Shift, Up, movegroupwindow"
                "$mod, Down, cyclenext, tiled, prev"
                "$mod, Down, changegroupactive, b"
                "$mod+Shift, Down, swapnext, tiled, prev"
                "$mod+Shift, Down, movegroupwindow, b"
                "$mod, Tab, workspace, previous"
                "$mod, Comma, focusmonitor, +1"
                "$mod+Shift, Comma, movecurrentworkspacetomonitor, +1"
                "$mod, Period, focusmonitor, -1"
                "$mod+Shift, Period, movecurrentworkspacetomonitor, -1"
                ", Print, exec, hyprshot -z -m region --clipboard-only"
                "$mod, Print, exec, hyprshot -z -m output --clipboard-only"
                "$mod, Space, exec, ${launcherCommand}"
              ]
              ++ (builtins.concatLists (
                builtins.genList (
                  i:
                  let
                    ws = i + 1;
                  in
                  [
                    "$mod, code:1${toString i}, workspace, ${toString ws}"
                    "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
                  ]
                ) 9
              ));
          }
          // lib.optionalAttrs (config.desktop.hyprland.monitors != [ ]) {
            monitor = config.desktop.hyprland.monitors;
          }
          // lib.optionalAttrs (config.desktop.hyprland.workspaceRules != [ ]) {
            workspace = config.desktop.hyprland.workspaceRules;
          };
      };

      programs.rofi = {
        enable = true;
        location = "center";
        package = pkgs.rofi;
        plugins = with pkgs; [ (rofi-calc.override { rofi-unwrapped = rofi-unwrapped; }) ];
        theme = lib.mkForce "${config.home.homeDirectory}/.config/rofi/themes/config.rasi";
        extraConfig = rec {
          modes = "drun,filebrowser,power-menu,run,calc";
          combi-modes = modes;
          modi = "combi,calc";
          show-icons = true;
          auto-select = true;
          hover-select = true;
          click-to-exit = true;
        };
      };

      home.file.".config/rofi/themes".source = ./rofi;

      services.swww.enable = true;

      programs.waybar = lib.mkIf (config.desktop.shell != "noctalia") {
        enable = true;
        systemd.enable = true;
      };

      services.hypridle = {
        enable = false;
        settings = {
          general = {
            lock_cmd = "pidof hyprlock || hyprlock";
            before_sleep_cmd = "loginctl lock-session";
            after_sleep_cmd = "hyprctl dispatch dpms on";
          };
          listener = [
          {
            timeout = 150;
            on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0";
            on-resume = "brightnessctl -rd rgb:kbd_backlight";
          }
          {
            timeout = 300;
            on-timeout = "loginctl lock-session";
          }
          {
            timeout = 330;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on && brightnessctl -r";
          }
          {
            timeout = 1800;
            on-timeout = "systemctl suspend";
          }
        ];
        };
      };
    };
}
