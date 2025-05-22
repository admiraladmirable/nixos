{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.kitty.enable = true;

  home.packages = with pkgs; [
    hyprcursor
    hyprutils
    hyprpicker
    hypridle
    hyprprop
    waybar
    grimblast
    brightnessctl
    playerctl
    xwayland
    wayland-protocols
    kdePackages.dolphin
    kdePackages.polkit-qt-1
    kdePackages.filelight
    kdePackages.kate
    kdePackages.xwaylandvideobridge
    # kdePackages.qtwayland
    dunst
  ];

  # home.pointerCursor = {
  #   inherit (config.stylix.cursor) name size package;
  #   enable = true;
  #   gtk.enable = true;
  # };

  gtk = {
    enable = true;
    cursorTheme = {
      inherit (config.stylix.cursor) package name;
    };

    iconTheme = {
      inherit (config.stylix.cursor) package name;
    };
  };
  qt.enable = true;

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  wayland.windowManager.hyprland = {
    enable = true;

    # These are configured at modules/nixos/display/stylix.nix
    package = null;
    portalPackage = null;

    plugins = with pkgs.hyprlandPlugins; [
      borders-plus-plus
      hyprspace
      hyprbars
    ];

    settings = {
      "$mod" = "SUPER";
      "$filemanager" = "dolphin";
      "$menu" = "rofi -show combi";

      exec-once = [
        "${pkgs.systemd}/bin/systemctl --user import-environment PATH"
        "uwsm finalize"
        "hyprdim"
      ];

      exec = [
        # "${pkgs.hyprland}/bin/hyprctl setcursor '${config.gtk.cursorTheme.name}' ${builtins.toString config.gtk.cursorTheme.size} &> /dev/null"
        "swww img /home/rmrf/Pictures/_DSC0148.jpg -t random --transition-duration 2"
      ];

      cursor = {
        # Fixes inconsistent cursor
        # no_hardware_cursors = 1;
        no_break_fs_vrr = 1;
        min_refresh_rate = 48;
      };

      env = [
        "NIXOS_OZONE_WL,1"
        # These are set by NixOS for nvidia I believe
        # "LIBVA_DRIVER_NAME,nvidia"
        # "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        # "GBM_BACKEND,nvidia-drm"
        "NVD_BACKEND,direct"
        "__GL_GSYNC_ALLOWED"
        "__GL_VRR_ALLOWED"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
        "GDK_BACKEND,wayland,x11,*"
        "QT_QPA_PLATFORM,wayland;xcb"
        "SDL_VIDEODRIVER,wayland"
        "CLUTTER_BACKEND,wayland"
        "QT_AUTO_SCREEN_SCALE_FACTOR,1"
        "HYPRCURSOR_THEME,BreezX-RosePine-Linux"
      ];

      input = {
        sensitivity = "0";
        accel_profile = "flat";
        force_no_accel = "1";
      };

      # Setup for xwaylandvideobridge
      # windowrule = {
      #   "opacity 0.0 override, class:^(xwaylandvideobridge)$"
      #   "noanim, class:^(xwaylandvideobridge)$"
      #   "noinitialfocus, class:^(xwaylandvideobridge)$"
      #   "maxsize 1 1, class:^(xwaylandvideobridge)$"
      #   "noblur, class:^(xwaylandvideobridge)$"
      #   "nofocus, class:^(xwaylandvideobridge)$"
      # };

      plugin = {
        borders-plus-plus = {
          add_borders = 1; # 0 - 9

          # you can add up to 9 borders
          # col.border_1 = "rgb (ffffff)";
          # col.border_2 = "rgb (2222 ff)";

          # -1 means "default" as in the one defined in general:border_size
          # border_size_1 = 10;
          # border_size_2 = -1;

          # makes outer edges match rounding of the parent. Turn on / off to better understand. Default = on.
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
        explicit_sync = 1;
        explicit_sync_kms = 1;
        direct_scanout = 1;
      };

      misc = {
        # disable_hyprland_logo = true;
        # disable_splash_rendering = true;
        force_default_wallpaper = 0;
        # vfr = false;
        vrr = 1;
      };

      experimental = {
        xx_color_management_v4 = true;
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
        };
      };

      general = {
        # gaps_in = 5;
        # gaps_out = 5;
        resize_on_border = true;
        snap = {
          enabled = true;
        };
        allow_tearing = true;
      };

      windowrule = [
        "immediate, class:(Marvel)$"
      ];

      monitor = [
        "DP-1, highrr, auto, 1, vrr, 1"
        "DP-2, highrr, auto-left, 1, vrr, 1"
      ];

      bind =
        [
          # "$mod, F, exec, firefox"
          ", Print, exec, grimblast copy area"
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
          "$mod, Space, exec, rofi -show combi"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (
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
          )
        );
    };
  };
}
