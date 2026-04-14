{ inputs, ... }:
{
  flake.modules.nixos.base =
    { pkgs, ... }:
    {
      imports = [ inputs.stylix.nixosModules.stylix ];

      stylix = {
        enable = true;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";

        cursor = {
          package = pkgs.rose-pine-cursor;
          name = "BreezeX-RosePine-Linux";
          size = 36;
        };

        fonts = {
          sizes.desktop = 12;

          serif = {
            name = "Iosevka";
            package = pkgs.nerd-fonts.iosevka;
          };

          sansSerif = {
            name = "Iosevka";
            package = pkgs.nerd-fonts.iosevka;
          };

          monospace = {
            name = "Fira Mono";
            package = pkgs.nerd-fonts.fira-mono;
          };

          emoji = {
            name = "Fira Code";
            package = pkgs.nerd-fonts.fira-code;
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
