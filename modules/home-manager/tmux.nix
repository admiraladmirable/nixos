{ pkgs, inputs, ... }:
{
  programs.tmux = {
    enable = true;
    clock24 = true;
    mouse = false;
    newSession = true;
    historyLimit = 5000;
    terminal = ",xterm*:Tc";
    keyMode = "vi";
    plugins = with pkgs; [
      tmuxPlugins.sensible
      tmuxPlugins.dracula
    ];
    extraConfig = ''
      set -g @plugin 'dracula/tmux'
    '';
  };
}
