{
  pkgs,
  lib,
  xdg-termfilepickers,
  ...
}:

{
  imports = [
    ../../modules/home
    ./hyprland
  ];

  fonts.fontconfig.enable = true;

  programs.zsh.shellAliases.update = "nh os switch ~/dotfiles";

  # enabled manually for catppuccin
  programs.rofi.enable = true;
  programs.foot.enable = true;
  services.dunst.enable = true;

  services.flatpak = {
    enable = true;
    packages = [ "org.vinegarhq.Sober" ];
    overrides = {
      "org.vinegarhq.Sober" = {
        Context = {
          filesystems = [
            "xdg-run/app/com.discordapp.Discord:create"
            "xdg-run/discord-ipc-0"
          ];
          devices = [ "input" ];
        };
      };
    };
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions.force = true;
      settings = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };

  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    plugins = {
      starship = pkgs.fetchFromGitHub {
        owner = "Rolv-Apneseth";
        repo = "starship.yazi";
        rev = "a63550b2f91f0553cc545fd8081a03810bc41bc0";
        sha256 = "sha256-PYeR6fiWDbUMpJbTFSkM57FzmCbsB4W4IXXe25wLncg=";
      };
    };

    initLua = ''
      require("starship"):setup()
    '';
  };

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

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
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

    # get flatpaks to show up in rofi
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:$HOME/.local/share/flatpak/exports/share";
  };

  home.stateVersion = "25.05";
}
