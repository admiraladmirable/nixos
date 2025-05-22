{
  pkgs,
  lib,
  config,
  ...
}:
{
  programs.rofi = {
    enable = true;
    location = "top";
    package = pkgs.rofi-wayland;

    plugins = with pkgs; [ (rofi-calc.override { rofi-unwrapped = rofi-wayland-unwrapped; }) ];

    # theme = ./themes/rofi/rounded.rasl;

    extraConfig = rec {
      # Modes
      modes = "drun,filebrowser,power-menu,run,calc";
      combi-modes = modes;
      modi = "combi,calc";

      show-icons = true;
      auto-select = true;
      hover-select = true;
      click-to-exit = true;
    };
  };
}
