{ ... }:
{
  flake.modules.homeManager.base =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        btop
        mission-center
        irssi
        newsflash
        figlet
        cbonsai
        fastfetch
        any-nix-shell
        alejandra
        nixfmt
        nixd
        kdePackages.kcalc
        kdePackages.okular
        blender
        xlights
        libxcrypt
        p7zip-rar
        piper
        bolt-launcher
        egl-wayland
        xeyes
        udiskie
      ];
    };
}
