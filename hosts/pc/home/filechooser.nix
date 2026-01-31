{
  pkgs,
  lib,
  xdg-termfilepickers,
  ...
}:

{
  services.xdg-desktop-portal-termfilepickers = {
    enable = true;
    package = xdg-termfilepickers.packages.${pkgs.stdenv.hostPlatform.system}.default;
    config = {
      # --app-id is used by a hyprland windowrule
      terminal_command = [
        (lib.getExe pkgs.foot)
        "--app-id=yazi"
      ];
    };
  };

  systemd.user.services.xdg-desktop-portal-termfilepickers = {
    Unit = {
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install = {
      WantedBy = lib.mkForce [ "graphical-session.target" ];
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
    config = {
      common = {
        default = [ "hyprland" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilepickers" ];
      };
    };
  };

  home.sessionVariables = {
    GTK_USE_PORTAL = "1"; # legacy
    GDK_DEBUG = "portals"; # termfilechooser
    QT_QPA_PLATFORMTHEME = "xdgdesktopportal";
  };
}
