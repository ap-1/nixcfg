{ pkgs, ... }:

{
  xdg.portal = {
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.common = {
      "org.freedesktop.impl.portal.Settings" = [ "gtk" ];
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
