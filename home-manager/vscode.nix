{
  pkgs,
  inputs,
  ...
}: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      jnoortheen.nix-ide
      donjayamanne.githistory
      eamodio.gitlens
      #
      # nhoizey.gremlins
      scalameta.metals
    ];
    #  ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    #   {
    #     name = "remote-ssh-edit";
    #     publisher = "ms-vscode-remote";
    #     version = "0.47.2";
    #     sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
    #   }
    # ];
  };
}
