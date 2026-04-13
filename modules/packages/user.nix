{ inputs, ... }:
{
  flake.modules.homeManager.desktop =
    { pkgs, ... }:
    {
      fonts.fontconfig.enable = true;

      home.packages = with pkgs; [
        ffmpeg-full
        libavif
        mpv
        btop
        irssi
        any-nix-shell
        figlet
        docker-compose
        newsflash
        alejandra
        nixfmt
        terraform
        terragrunt
        kdePackages.kcalc
        fastfetch
        kubectl
        kubernetes-helm
        xlights
        nerd-fonts.droid-sans-mono
        nixd
        gst_all_1.gstreamer
        opentofu
        awscli2
        cilium-cli
        hubble
        brave
        chromium
        xeyes
        cbonsai
        blender
        iptables
        wine64Packages.wayland
        mission-center
        libxcrypt
        p7zip-rar
        piper
        bolt-launcher
        yq-go
        egl-wayland
        vcv-rack-custom
        (cardinal.override { libjack2 = pkgs.pipewire.jack; })
        qpwgraph
        reaper
        age
        openssl
        kdePackages.okular
        udiskie
        netcat
        inetutils
        dnsutils
        ethtool
        bmon
        claude-code
        inputs.codex-cli-nix.packages.${pkgs.stdenv.hostPlatform.system}.default
        lmstudio
        llama-cpp
        opencode
        opencode-desktop
      ];
    };
}
