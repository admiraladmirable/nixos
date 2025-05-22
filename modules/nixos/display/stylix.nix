{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
with lib;
{
  options.stylix-module.enable = mkEnableOption "Enable Stylix";

  config = mkIf config.stylix-module.enable {
    stylix = {
      enable = true;

      base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-frappe.yaml";

      cursor = {
        package = inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default;
        name = "BreezX-RosePine-Linux";
        size = 48;
      };

      fonts = {
        sizes = {
          desktop = 12;
        };
        serif = {
          # name = "Fira Code";
          # package = pkgs.nerd-fonts.fira-code;
          name = "Iosevka";
          package = pkgs.nerd-fonts.iosevka;
        };

        sansSerif = {
          # name = "Fira Code";
          # package = pkgs.nerd-fonts.fira-code;
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
}
