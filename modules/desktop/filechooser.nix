{ inputs, ... }: {
  flake.modules.homeManager.filechooser =
    {
      pkgs,
      lib,
      ...
    }:
    {
      imports = [
        inputs.xdg-termfilepickers.homeManagerModules.default
      ];

      programs.yazi = {
        enable = true;
        enableZshIntegration = true;
        shellWrapperName = "y";
        plugins.starship = pkgs.fetchFromGitHub {
          owner = "Rolv-Apneseth";
          repo = "starship.yazi";
          rev = "a63550b2f91f0553cc545fd8081a03810bc41bc0";
          sha256 = "sha256-PYeR6fiWDbUMpJbTFSkM57FzmCbsB4W4IXXe25wLncg=";
        };
        initLua = ''
          require("starship"):setup()
        '';
      };

      services.xdg-desktop-portal-termfilepickers = {
        enable = true;
        package = inputs.xdg-termfilepickers.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
          PartOf = lib.mkForce [ "xdg-desktop-portal.service" ];
          After = lib.mkAfter [ "xdg-desktop-portal.service" ];
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
    };
}
