{

  lib,
  ...
}:
let
  styleDir = builtins.path {
    name = "waybar-style";
    path = ./waybar;
  };
in
{
  stylix.targets.waybar = {
    enable = false;
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;

    style = lib.mkAfter (builtins.readFile ./waybar/mechabar/style.css);
    # style = "${styleDir}/style.css";

    settings = {
      mainBar = (builtins.fromJSON (builtins.readFile ./waybar/mechabar/config.json));
      # mainBar = {
      # };
    };
  };
}
