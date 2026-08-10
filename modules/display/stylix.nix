{ inputs, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      stylix = {
        enable = true;
        polarity = "dark";
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";

        cursor = {
          package = pkgs.rose-pine-cursor;
          name = "BreezeX-RosePine-Linux";
          size = 36;
        };

        fonts = {
          sizes.desktop = 12;

          serif = {
            name = "Noto Serif";
            package = pkgs.noto-fonts;
          };

          sansSerif = {
            name = "Noto Sans";
            package = pkgs.noto-fonts;
          };

          monospace = {
            name = "JetBrains Mono";
            package = pkgs.jetbrains-mono;
          };

          emoji = {
            name = "Noto Color Emoji";
            package = pkgs.noto-fonts-color-emoji;
          };
        };
      };
    };

  flake.modules.homeManager.base = {
    stylix.targets.firefox = {
      enable = true;
      profileNames = [
        "rmrf"
        "rmrf-work"
      ];
    };
  };
}
