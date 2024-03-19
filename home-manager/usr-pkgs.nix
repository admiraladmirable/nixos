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
      npins
      docker-compose
      # Topl dev dependencies
      graalvm-ce
      (sbt.override { jre = pkgs.graalvm-ce; })
      (scala.override { jre = pkgs.graalvm-ce; })
      # metals
      coursier
      terraform
      terragrunt
      checkov
      (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
    ];
}
