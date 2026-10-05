{ inputs, ... }: {
  flake.modules.nixos.filechooser =
    { pkgs, lib, ... }:
    {
      imports = [
        "${inputs.nixpkgs-termfilepickers}/nixos/modules/config/xdg/portals/termfilepickers.nix"
      ];

      xdg.portal.termfilepickers = {
        enable = true;
        package =
          inputs.nixpkgs-termfilepickers.legacyPackages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-termfilepickers;
        # --app-id is used by a hyprland windowrule
        settings.terminal_command = [
          (lib.getExe pkgs.foot)
          "--app-id=yazi"
        ];
      };
    };

  flake.modules.homeManager.filechooser =
    {
      osConfig,
      pkgs,
      ...
    }:
    {
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

      xdg.portal = {
        enable = true;
        # home-manager points xdg-desktop-portal at its own portals dir, hiding system portals
        extraPortals = [
          pkgs.xdg-desktop-portal-hyprland
          osConfig.xdg.portal.termfilepickers.package
        ];
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
