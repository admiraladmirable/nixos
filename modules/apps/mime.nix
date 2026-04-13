{ ... }:
{
  flake.modules.homeManager.workstation = {
    xdg.configFile."xdg-desktop-portal/hyprland-portals.conf".text = ''
      [preferred]
      default=hyprland;gtk
      org.freedesktop.impl.portal.FileChooser=kde
    '';

    xdg.mimeApps = {
      enable = true;
      associations.added = {
        "application/zip" = [ "org.kde.ark.desktop" ];
        "application/x-7z-compressed" = [ "org.kde.ark.desktop" ];
        "application/x-bzip-compressed-tar" = [ "org.kde.ark.desktop" ];
        "application/x-compressed-tar" = [ "org.kde.ark.desktop" ];
        "application/x-rar" = [ "org.kde.ark.desktop" ];
        "application/x-tar" = [ "org.kde.ark.desktop" ];
        "application/x-xz-compressed-tar" = [ "org.kde.ark.desktop" ];
        "application/vnd.rar" = [ "org.kde.ark.desktop" ];
      };
      defaultApplications = {
        "application/zip" = [ "org.kde.ark.desktop" ];
        "application/x-7z-compressed" = [ "org.kde.ark.desktop" ];
        "application/x-bzip-compressed-tar" = [ "org.kde.ark.desktop" ];
        "application/x-compressed-tar" = [ "org.kde.ark.desktop" ];
        "application/x-rar" = [ "org.kde.ark.desktop" ];
        "application/x-tar" = [ "org.kde.ark.desktop" ];
        "application/x-xz-compressed-tar" = [ "org.kde.ark.desktop" ];
        "application/vnd.rar" = [ "org.kde.ark.desktop" ];
      };
    };
  };
}
