{
  flake.modules.homeManager.theme =
    { pkgs, ... }:
    {
      fonts.fontconfig.enable = true;

      xdg.userDirs = {
        enable = true;
        createDirectories = true;
        setSessionVariables = true;
      };

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
    };
}
