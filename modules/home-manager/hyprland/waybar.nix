{
  pkgs,
  lib,
  ...
}:
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    style = lib.mkAfter (builtins.readFile ./waybar/style.css);

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        # output = "eDP-1";
        output = "DP-2";

        modules-left = [
          "hyprland/workspaces"
          "hyprland/window"
        ];
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "network"
          "cpu"
          "memory"
          "temperature"
          "battery"
          "tray"
        ];

        "hyprland/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
          format-icons = {
            "1" = "󰎤";
            "2" = "󰈹";
            "3" = "󰱼";
            "4" = "󰎆";
            "5" = "󰧮";
            "6" = "󰙯";
            "7" = "󰒓";
            "8" = "󰗃";
            "9" = "󰓓";
            "10" = "󰄛";
          };
        };

        "hyprland/window" = {
          format = "  {}";
        };

        clock = {
          format = "󰥔  %a %d %b %H:%M";
          tooltip-format = "<big>%Y-%m-%d</big>\n%H:%M:%S";
        };

        cpu = {
          format = " {usage}%";
          tooltip = false;
        };

        memory = {
          format = "󰍛 {used} MiB";
          tooltip = false;
        };

        temperature = {
          critical-threshold = 75;
          format = "󰔏 {temperature}°C";
        };

        network = {
          format-wifi = "󰤨 {essid} ({signalStrength}%)";
          format-ethernet = "󰈀 {ifname}";
          format-disconnected = "󰤮 Disconnected";
        };

        pulseaudio = {
          format = "󰕾 {volume}%";
          format-muted = "󰝟 Muted";
        };

        battery = {
          states = {
            good = 80;
            warning = 30;
            critical = 15;
          };

          format = "󰁹 {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󰚥 {capacity}%";
        };

        tray = {
          spacing = 8;
        };
      };
    };
  };
}
