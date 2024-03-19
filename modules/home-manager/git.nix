{
  pkgs,
  inputs,
  ...
}: {
  programs.git = {
    enable = true;
    userName = "admiraladmirable";
    userEmail = "rick.morrow1204@gmail.com";
    aliases = {
      undo = "reset HEAD~1 --mixed";
    };
    extraConfig = {
      credential.helper = "${
          pkgs.git.override { withLibsecret = true; }
        }/bin/git-credential-libsecret";
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
