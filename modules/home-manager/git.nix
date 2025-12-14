{ pkgs, inputs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      credential.helper = "${pkgs.git.override { withLibsecret = true; }}/bin/git-credential-libsecret";
      user = {
        name = "rmrf";
        email = "rick.morrow1204@gmail.com";
      };
      aliases = {
        undo = "reset HEAD~1 --mixed";
      };
      color = {
        ui = "auto";
      };
      push = {
        default = "simple";
        autoSetupRemote = "true";
      };
    };
  };
}
