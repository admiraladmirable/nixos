{
  inputs,
  lib,
  config,
  ...
}:
{
  config.flake.modules.homeManager.hyprland =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      # Catppuccin Frappé via stylix base16 (base00..base0F as "#rrggbb").
      # Change the stylix base16Scheme and Noctalia follows automatically.
      c = config.lib.stylix.colors.withHashtag;
    in
    {
      config = lib.mkIf (config.desktop.shell == "noctalia") {
        programs.noctalia = {
          enable = true;
          package = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
          # systemd.enable = true;

          # Export GUI changes with: noctalia config export merged > modules/display/noctalia-settings.toml
          settings = builtins.fromTOML (builtins.readFile ./noctalia-settings.toml);
          # Custom palette -> ~/.config/noctalia/palettes/stylix.json
          customPalettes.stylix.dark = lib.mkForce {
            mPrimary = c.base0E; # mauve
            mOnPrimary = c.base00; # base
            mSecondary = c.base0D; # blue
            mOnSecondary = c.base00;
            mTertiary = c.base0C; # teal
            mOnTertiary = c.base00;
            mError = c.base08; # red
            mOnError = c.base00;
            mSurface = c.base00; # base (background)
            mOnSurface = c.base05; # text
            mSurfaceVariant = c.base02; # surface0
            mOnSurfaceVariant = c.base04; # surface2
            mOutline = c.base03; # surface1
            mShadow = c.base01; # mantle
            mHover = c.base02;
            mOnHover = c.base05;

            # Required by v5: a palette without a terminal block is silently rejected.
            terminal = {
              foreground = c.base05;
              background = c.base00;
              cursor = c.base06; # rosewater
              cursorText = c.base00;
              selectionFg = c.base05;
              selectionBg = c.base02;
              normal = {
                black = c.base03;
                red = c.base08;
                green = c.base0B;
                yellow = c.base0A;
                blue = c.base0D;
                magenta = c.base0E;
                cyan = c.base0C;
                white = c.base05;
              };
              bright = {
                black = c.base04;
                red = c.base08;
                green = c.base0B;
                yellow = c.base0A;
                blue = c.base0D;
                magenta = c.base0E;
                cyan = c.base0C;
                white = c.base06;
              };
            };
          };
        };
      };
    };
}
