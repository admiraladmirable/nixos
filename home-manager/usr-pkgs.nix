{ pkgs, ... }:

{
  home.packages = with pkgs; 
    [
      ffmpeg
      mpv
      btop
      irssi
      any-nix-shell
      figlet
      ranger
      deluge
      npins
    ];
}
