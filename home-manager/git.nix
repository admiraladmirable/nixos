{ pkgs, inputs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Claus Mouse";
    userEmail = "11484197-senoraraton@users.noreply.gitlab.com";
    aliases = {
      undo = "reset HEAD~1 --mixed";
    };
    extraConfig = {
      color = {
        ui = "auto";
      };
      push = {
        default = "simple";
      };
    };
  };
}
