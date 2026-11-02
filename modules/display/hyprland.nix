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
          # Upstream's setPath uses systemd.user.extraConfig, removed in current
          # nixpkgs. Default is false for Hyprland >= 0.41.2 and UWSM manages the
          # session env, so keep it off to avoid the removed-option assertion.
          systemd.setPath.enable = false;
          package = pkgs.hyprland;
          portalPackage = pkgs.xdg-desktop-portal-hyprland;
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
          pkgs.xdg-desktop-portal-hyprland
          pkgs.kdePackages.xdg-desktop-portal-kde
        ];
        configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
        config.common = {
          default = [
            "hyprland"
            "kde"
          ];
          "org.freedesktop.impl.portal.FileChooser" = [ "kde" ];
        };
      };

      # xdph spawns hyprland-share-picker (the "Screen Capture (PipeWire)"
      # source selector OBS pops) as a slim Qt6 app. Stylix exports
      # QT_STYLE_OVERRIDE=kvantum session-wide, and that Kvantum build
      # infinite-recurses in QProxyStyle::standardPalette -> SIGSEGV, so the
      # selector never appears. Full Qt apps are unaffected; force a plain
      # style only for the portal and its child picker.
      systemd.user.services.xdg-desktop-portal-hyprland = {
        overrideStrategy = "asDropin";
        # Screenshot support is registered only when grim is on the portal PATH.
        path = [
          pkgs.grim
          pkgs.slurp
        ];
        environment.QT_STYLE_OVERRIDE = "Fusion";
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
    {
      pkgs,
      lib,
      config,
      ...
    }:
    let
      noctaliaPackage = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
      caelestiaPackage =
        inputs.caelestia-shell.packages.${pkgs.stdenv.hostPlatform.system}.caelestia-shell;
      noctaliaExe = lib.getExe noctaliaPackage;
      caelestiaExe = lib.getExe caelestiaPackage;
      noctaliaIpc = "${noctaliaExe} msg";
      launcherCommand =
        if config.desktop.shell == "noctalia" then
          "${noctaliaIpc} panel-toggle launcher"
        else
          "rofi -show combi";
      screenshotEditor = pkgs.writeShellApplication {
        name = "screenshot-editor";
        runtimeInputs = with pkgs; [
          grimblast
          satty
          wl-clipboard
          coreutils
        ];
        text = ''
          capture=$(mktemp --suffix=.ppm)
          trap 'rm -f "$capture"' EXIT
          # Avoid PNG compression before the editor opens.
          grimblast --freeze --filetype ppm save "''${1:-area}" "$capture"
          directory="${config.xdg.userDirs.pictures}/Screenshots"
          mkdir -p "$directory"
          satty --filename "$capture" \
            --output-filename "$directory/Screenshot-%Y%m%d-%H%M%S.png" \
            --copy-command wl-copy
        '';
      };
      defaultLayout = "dwindle";
      masterOrientation = "left";
      scrollingDirection = "right";
      scrollingColumnWidth = 0.6;
      c = config.lib.stylix.colors;
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
          satty
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
        # Stylix's gtk/hm.nix already sets gtk4.theme = config.gtk.theme; lower
        # our priority so the two identical definitions don't collide (gtk4.theme
        # is a unique option). mkDefault keeps a fallback if Stylix is ever off.
        gtk4.theme = lib.mkDefault config.gtk.theme;
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
        GSK_RENDERER = "ngl";
      };

      # Hyprland 0.55+ reads $XDG_CONFIG_HOME/hypr/hyprland.lua and ignores
      # hyprland.conf whenever the Lua file exists. Each `settings` attribute
      # renders as an `hl.<name>(...)` call; see the Lua API stubs shipped in
      # ${pkgs.hyprland}/share/hypr/stubs/hl.meta.lua.
      wayland.windowManager.hyprland =
        let
          toLua = lib.generators.toLua { };
          inline = lib.generators.mkLuaInline;
          mod = "SUPER";

          # hl.bind(keys, action) where action is a raw Lua dispatcher or function.
          bind = keys: action: {
            _args = [
              keys
              (inline action)
            ];
          };
          # hl.bind(keys, action, { mouse = true }) for held-button drag binds.
          bindMouse = keys: action: {
            _args = [
              keys
              (inline action)
              { mouse = true; }
            ];
          };
          exec = cmd: "hl.dsp.exec_cmd(${toLua cmd})";
          # Hyprlang fired every bind sharing a key; Lua keeps one bind per key,
          # so run the dispatchers in sequence from a single function.
          dispatchAll =
            actions: "function()\n${lib.concatMapStrings (a: "  hl.dispatch(${a})\n") actions}end";
          # Replaces `hyprctl keyword general:layout ...`.
          setLayout = layout: "function() hl.config({ general = { layout = ${toLua layout} } }) end";
          layoutMsg = msg: "hl.dsp.layout(${toLua msg})";

          startupCommands = [
            "${pkgs.kdePackages.kwallet-pam}/libexec/pam_kwallet_init"
            "wl-paste --type text --watch cliphist store"
            "hyprdim"
            "udiskie"
            "${noctaliaExe}"
            # Loudly surface a failed home-manager activation: when linkGeneration
            # aborts, packages still update but dotfiles stay frozen on an old
            # generation, so login silently uses stale configs. Warn at login.
            "sh -c 'sleep 5; systemctl is-failed --quiet home-manager-rmrf.service && ${pkgs.libnotify}/bin/notify-send -u critical \"home-manager activation FAILED\" \"Dotfiles are stale — login is using an old generation. Check: systemctl status home-manager-rmrf.service\"'"
            "uwsm finalize"
          ];

          bezier = name: p1: p2: {
            _args = [
              name
              {
                type = "bezier";
                points = [
                  p1
                  p2
                ];
              }
            ];
          };
          animation =
            leaf: speed: curve: style:
            {
              inherit leaf speed;
              enabled = true;
              bezier = curve;
            }
            // lib.optionalAttrs (style != null) { inherit style; };
        in
        {
          enable = true;
          package = null;
          portalPackage = null;
          systemd.variables = [ "--all" ];
          systemd.enable = false;

          configType = "lua";

          settings = {
            config = {
              cursor = {
                no_break_fs_vrr = 2;
                min_refresh_rate = 60;
                no_hardware_cursors = true;
              };

              input = {
                sensitivity = 0;
                accel_profile = "flat";
                force_no_accel = true;
              };

              # 0.56 added a gate on forwarding modifiers to an input-capture
              # client and defaulted it off, so SUPER stopped reaching the machine
              # driven over lan-mouse. 0.55.2 had no such option. Upstream default
              # is false; we capture, so we need it on.
              input_capture.capture_modifiers = true;

              xwayland.force_zero_scaling = true;

              animations.enabled = true;

              dwindle.preserve_split = true;

              master = {
                orientation = masterOrientation;
                mfact = 0.55;
                new_status = "slave";
                new_on_top = true;
              };

              scrolling = {
                direction = scrollingDirection;
                column_width = scrollingColumnWidth;
                # wrap_focus = true;
                explicit_column_widths = "0.333, 0.5, 0.667, 1.0";
              };

              render = {
                # Keep direct scanout available for games, not regular fullscreen windows.
                direct_scanout = 2;
              };

              misc = {
                force_default_wallpaper = 0;
                # Regular fullscreen windows should stay at the monitor's normal rate.
                vrr = 3;
              };

              decoration.rounding = 10;

              general = {
                # Upstream example look (2px, 45deg two-tone active gradient,
                # translucent inactive) in Stylix colors. Stylix's hyprland
                # target writes these same flat keys with solid colors; force
                # ours so only one definition is rendered.
                border_size = 2;
                "col.active_border" = lib.mkForce {
                  colors = [
                    "rgba(${c.base0D}ee)"
                    "rgba(${c.base0B}ee)"
                  ];
                  angle = 45;
                };
                "col.inactive_border" = lib.mkForce "rgba(${c.base03}aa)";
                layout = defaultLayout;
                resize_on_border = true;
                snap.enabled = true;
                allow_tearing = true;
              };
            };

            # Rendered before `animation` via the default importantPrefixes.
            curve = [
              (bezier "wind" [ 0.05 0.9 ] [ 0.1 1.05 ])
              (bezier "winIn" [ 0.1 1.1 ] [ 0.1 1.1 ])
              (bezier "winOut"
                [
                  0.3
                  (-0.3)
                ]
                [ 0 1 ]
              )
              (bezier "liner" [ 1 1 ] [ 1 1 ])
            ];

            animation = [
              (animation "windows" 6 "wind" "slide")
              (animation "windowsIn" 6 "winIn" "slide")
              (animation "windowsOut" 5 "winOut" "slide")
              (animation "windowsMove" 5 "wind" "slide")
              (animation "border" 1 "liner" null)
              (animation "borderangle" 30 "liner" "once")
              (animation "fade" 10 "default" null)
              (animation "workspaces" 5 "wind" null)
            ];

            on = {
              _args = [
                "hyprland.start"
                (inline "function()\n${lib.concatMapStrings (c: "  hl.exec_cmd(${toLua c})\n") startupCommands}end")
              ];
            };

            window_rule = [
              {
                match.class = "^(org.satty.Satty)$";
                float = true;
              }
            ];

            bind = [
              (bind "${mod} + V" (exec "cliphist list | rofi -dmenu | cliphist decode | wl-copy"))
              (bind "${mod} + T" (exec "ghostty"))
              (bind "${mod} + C" "hl.dsp.window.close()")
              (bind "${mod} + SHIFT + C" "hl.dsp.window.kill()")
              (bind "${mod} + E" (setLayout "dwindle"))
              (bind "${mod} + D" (setLayout "dwindle"))
              (bind "${mod} + M" (setLayout "master"))
              (bind "${mod} + S" (setLayout "scrolling"))
              (bind "${mod} + F" "hl.dsp.window.fullscreen()")
              (bind "${mod} + G" "hl.dsp.group.toggle()")
              (bind "${mod} + SHIFT + G" "hl.dsp.window.move({ out_of_group = true })")
              (bind "${mod} + P" (exec "1password --quick-access"))
              (bind "${mod} + SHIFT + F" ''hl.dsp.window.float({ action = "toggle" })'')
              (bind "${mod} + SHIFT + R" "hl.dsp.reload_config()")
              (bind "${mod} + Left" ''hl.dsp.focus({ workspace = "m-1" })'')
              (bind "${mod} + SHIFT + Left" ''hl.dsp.window.move({ workspace = "m-1", follow = false })'')
              (bind "${mod} + Right" ''hl.dsp.focus({ workspace = "m+1" })'')
              (bind "${mod} + SHIFT + Right" ''hl.dsp.window.move({ workspace = "m+1", follow = false })'')
              (bind "${mod} + Up" (dispatchAll [
                "hl.dsp.window.cycle_next({ tiled = true })"
                "hl.dsp.group.next()"
              ]))
              (bind "${mod} + SHIFT + Up" (dispatchAll [
                "hl.dsp.window.swap({ next = true })"
                "hl.dsp.group.move_window()"
              ]))
              (bind "${mod} + Down" (dispatchAll [
                "hl.dsp.window.cycle_next({ tiled = true, next = false })"
                "hl.dsp.group.prev()"
              ]))
              (bind "${mod} + SHIFT + Down" (dispatchAll [
                "hl.dsp.window.swap({ prev = true })"
                "hl.dsp.group.move_window({ forward = false })"
              ]))
              (bind "${mod} + Tab" ''hl.dsp.focus({ workspace = "previous" })'')
              (bind "${mod} + Comma" ''hl.dsp.focus({ monitor = "+1" })'')
              (bind "${mod} + SHIFT + Comma" ''hl.dsp.workspace.move({ monitor = "+1" })'')
              (bind "${mod} + Period" ''hl.dsp.focus({ monitor = "-1" })'')
              (bind "${mod} + SHIFT + Period" ''hl.dsp.workspace.move({ monitor = "-1" })'')
              (bind "Print" (exec "${lib.getExe screenshotEditor} area"))
              (bind "${mod} + Print" (exec "${lib.getExe screenshotEditor} output"))
              (bind "${mod} + Space" (exec launcherCommand))

              # Drag with SUPER + LMB to move, SUPER + RMB to resize.
              (bindMouse "${mod} + mouse:272" "hl.dsp.window.drag()")
              (bindMouse "${mod} + mouse:273" "hl.dsp.window.resize()")

              # Dwindle layout controls.
              (bind "${mod} + CTRL + E" (layoutMsg "togglesplit"))

              # Master layout controls.
              (bind "${mod} + Return" (layoutMsg "swapwithmaster auto"))
              (bind "${mod} + CTRL + Left" (layoutMsg "orientationleft"))
              (bind "${mod} + CTRL + Right" (layoutMsg "orientationright"))
              (bind "${mod} + CTRL + Up" (layoutMsg "orientationtop"))
              (bind "${mod} + CTRL + Down" (layoutMsg "orientationbottom"))

              # Scrolling layout controls.
              (bind "${mod} + ALT + Comma" (layoutMsg "move -col"))
              (bind "${mod} + ALT + Period" (layoutMsg "move +col"))
              (bind "${mod} + ALT + Up" (layoutMsg "focus u"))
              (bind "${mod} + ALT + Down" (layoutMsg "focus d"))
              (bind "${mod} + ALT + SHIFT + Comma" (layoutMsg "swapcol l"))
              (bind "${mod} + ALT + SHIFT + Period" (layoutMsg "swapcol r"))
              (bind "${mod} + ALT + Return" (layoutMsg "promote"))
              (bind "${mod} + ALT + Minus" (layoutMsg "colresize -conf"))
              (bind "${mod} + ALT + Equal" (layoutMsg "colresize +conf"))
            ]
            ++ builtins.concatLists (
              builtins.genList (
                i:
                let
                  ws = toString (i + 1);
                  key = "code:1${toString i}";
                in
                [
                  (bind "${mod} + ${key}" "hl.dsp.focus({ workspace = ${ws} })")
                  (bind "${mod} + SHIFT + ${key}" "hl.dsp.window.move({ workspace = ${ws} })")
                ]
              ) 9
            );
          }
          // lib.optionalAttrs (config.desktop.hyprland.monitors != [ ]) {
            monitor = config.desktop.hyprland.monitors;
          }
          // lib.optionalAttrs (config.desktop.hyprland.workspaceRules != [ ]) {
            workspace_rule = config.desktop.hyprland.workspaceRules;
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

      services.awww.enable = true;

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
