{ pkgs, inputs, ... }:

{
  programs.kitty = {
    enable = true;
    font.name = "Source Code Pro Medium";
    font.size = 16.0;
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      update_check_interval = 0;
    };
    shellIntegration.enableZshIntegration = true;
    theme = "Blazer";
    extraConfig = ''
      confirm_os_window_close 0
    '';
  };
}
