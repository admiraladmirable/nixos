{
  pkgs,
  lib,
  ...
}:
{
  programs.kitty.enable = true;

  home.packages = with pkgs; [
    hyprcursor
    hyprutils
    xdg-desktop-portal-hyprland
    hyprpicker
    hypridle
    waybar
  ];

  home.sessionVariables.NIXOS_OZONE_WL = "1";

  wayland.windowManager.hyprland = {
    enable = true;

    plugins = with pkgs.hyprlandPlugins; [
      borders-plus-plus
      hyprspace
      hyprbars
    ];

    settings = {
      "$mod" = "SUPER";

      env = [
        "NIXOS_OZONE_WL,1"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"
      ];

      input = {
        sensitivity = ".2";
        accel_profile = "flat";
      };

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

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        vrr = 1;
      };
      general = {
        snap = {
          enabled = true;
        };
      };

      monitor = [
        "DP-1, highrr, auto, 1, vrr, 1"
        "DP-2, highrr, auto-left, 1, vrr, 1"
      ];

      bind =
        [
          "$mod, F, exec, firefox"
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
