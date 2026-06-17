{
  inputs,
  lib,
  config,
  ...
}:
{
  config.flake.modules.homeManager.hyprland =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # Catppuccin Frappé via stylix base16 (base00..base0F as "#rrggbb").
      # Change the stylix base16Scheme and Noctalia follows automatically.
      c = config.lib.stylix.colors.withHashtag;
    in
    {
      imports = [ inputs.noctalia.homeModules.default ];

      config = lib.mkIf (config.desktop.shell == "noctalia") {
        programs.noctalia = {
          enable = true;
          package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
          # systemd.enable = true;

          # v5 settings -> ~/.config/noctalia/config.toml (TOML, top-level tables).
          # Migrated from the runtime ~/.local/state/noctalia/settings.toml so the
          # bar/theme/wallpaper layout is reproducible from this repo.
          settings = {
            bar.default = {
              capsule = true;
              center = [ "workspaces" ];
              start = [ "launcher" "clock" "wallpaper" ];
              end = [
                "media"
                "tray"
                "notifications"
                "clipboard"
                "network"
                "bluetooth"
                "volume"
                "brightness"
                "battery"
                "session"
              ];
              capsule_group = [
                {
                  fill = "surface_variant";
                  id = "g1";
                  members = [ "clipboard" "network" ];
                  opacity = 1.0;
                  padding = 6.0;
                }
              ];
            };

            location.auto_locate = true;

            # Launch apps via systemd-run (separate cgroup) instead of as direct
            # children. This also reparents launches off Noctalia's process, so
            # they don't inherit the ambient CAP_SYS_NICE that the Hyprland
            # security wrapper leaks into the session — which otherwise makes
            # Steam's bwrap abort ("Unexpected capabilities but not setuid").
            shell.launch_apps_as_systemd_services = true;

            lockscreen_widgets = {
              enabled = false;
              schema_version = 2;
              widget_order = [ "lockscreen-login-box@DP-2" ];
              grid = {
                cell_size = 16;
                major_interval = 4;
                visible = true;
              };
              widget."lockscreen-login-box@DP-2" = {
                box_height = 0.0;
                box_width = 0.0;
                cx = 1720.0;
                cy = 1317.0;
                output = "DP-2";
                rotation = 0.0;
                type = "login_box";
                settings = {
                  background_color = "surface_variant";
                  background_opacity = 0.88;
                  background_radius = 12.0;
                  input_opacity = 1.0;
                  input_radius = 6.0;
                  show_login_button = true;
                };
              };
            };

            theme = {
              mode = "dark";
              source = "custom";
              custom_palette = "stylix";
            };

            wallpaper = {
              directory = "/home/rmrf/Pictures";
              default.path = "/home/rmrf/Pictures/_DSC0148.jpg";
              last.path = "/home/rmrf/Pictures/_DSC0148.jpg";
              monitors."DP-2".path = "/home/rmrf/Pictures/_DSC0148.jpg";
            };

            widget = {
              clock.capsule = true;
              launcher.capsule = true;
              media.capsule = true;
              volume = {
                capsule = true;
                show_label = false;
              };
              wallpaper.capsule = true;
              workspaces.capsule = true;
            };
          };

          # Custom palette -> ~/.config/noctalia/palettes/stylix.json
          customPalettes.stylix.dark = {
            mPrimary = c.base0E; # mauve
            mOnPrimary = c.base00; # base
            mSecondary = c.base0D; # blue
            mOnSecondary = c.base00;
            mTertiary = c.base0C; # teal
            mOnTertiary = c.base00;
            mError = c.base08; # red
            mOnError = c.base00;
            mSurface = c.base00; # base (background)
            mOnSurface = c.base05; # text
            mSurfaceVariant = c.base02; # surface0
            mOnSurfaceVariant = c.base04; # surface2
            mOutline = c.base03; # surface1
            mShadow = c.base01; # mantle
            mHover = c.base02;
            mOnHover = c.base05;

            # Required by v5: a palette without a terminal block is silently rejected.
            terminal = {
              foreground = c.base05;
              background = c.base00;
              cursor = c.base06; # rosewater
              cursorText = c.base00;
              selectionFg = c.base05;
              selectionBg = c.base02;
              normal = {
                black = c.base03;
                red = c.base08;
                green = c.base0B;
                yellow = c.base0A;
                blue = c.base0D;
                magenta = c.base0E;
                cyan = c.base0C;
                white = c.base05;
              };
              bright = {
                black = c.base04;
                red = c.base08;
                green = c.base0B;
                yellow = c.base0A;
                blue = c.base0D;
                magenta = c.base0E;
                cyan = c.base0C;
                white = c.base06;
              };
            };
          };
        };
      };
    };
}
