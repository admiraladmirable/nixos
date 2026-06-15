{ ... }:
{
  flake.modules.nixos.base = {
    virtualisation.docker.enable = true;

    # docker-sbx's nerdbox shim creates loop devices to mount per-sandbox
    # rwlayer images. Default NixOS perms are root:disk 0660 — grant the
    # kvm group (already trusted for VM access) instead of widening to disk.
    services.udev.extraRules = ''
      KERNEL=="loop-control", GROUP="kvm", MODE="0660"
      KERNEL=="loop[0-9]*", GROUP="kvm", MODE="0660"
    '';
  };

  flake.modules.homeManager.base =
    { pkgs, lib, ... }:
    {
      home.packages = with pkgs; [
        docker-compose
        docker-credential-helpers
        docker-sbx
      ];

      home.activation.configureDockerGhcrCredentialHelper = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        docker_config="$HOME/.docker/config.json"
        docker_tmp="$docker_config.hm-ghcr-helper"
        jq_filter='
          .credHelpers = ((if (.credHelpers | type) == "object" then .credHelpers else {} end) + {"ghcr.io": "secretservice"})
          | if (.auths | type) == "object" then
              .auths |= del(.["ghcr.io"], .["https://ghcr.io"])
            else
              .
            end
        '

        mkdir -p "$(dirname "$docker_config")"

        if [ -s "$docker_config" ]; then
          ${pkgs.jq}/bin/jq "$jq_filter" "$docker_config" > "$docker_tmp"
        else
          ${pkgs.jq}/bin/jq -n "$jq_filter" > "$docker_tmp"
        fi

        chmod 0600 "$docker_tmp"
        mv "$docker_tmp" "$docker_config"
      '';
    };
}
