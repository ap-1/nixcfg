{ pkgs, lib, xdg-termfilepickers, ...}:

{
  imports = [
    ../../modules/home/git.nix
    ../../modules/home/gpg.nix
    ../../modules/home/neovim.nix
    ../../modules/home/shell.nix
    ../../modules/home/ssh.nix
    ../../modules/home/nixpkgs.nix
  ];

  home.packages = with pkgs; [
    libnotify
    nerd-fonts.fira-code
  ];

  fonts.fontconfig.enable = true;

  programs.zsh.shellAliases.update = "nh os switch";

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
  
  catppuccin = {
    enable = true;
    flavor = "mocha";

    eza.enable = true;
    yazi.enable = true;
    nvim.enable = true;
    atuin.enable = true;
    starship.enable = true;
    hyprland.enable = true;
    bat.enable = true;
    foot.enable = true;
    rofi.enable = true;
    dunst.enable = true;
    waybar.enable = true;
  };

  programs.bat.enable = true;
  programs.foot.enable = true;
  programs.rofi.enable = true;
  services.dunst.enable = true;
  programs.waybar.enable = true;

  services.xdg-desktop-portal-termfilepickers = {
    enable = true;
    package = xdg-termfilepickers.packages.${pkgs.stdenv.hostPlatform.system}.default;
    config = {
      # --app-id used by a hyprland windowrule
      terminal_command = [(lib.getExe pkgs.foot)];
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
  };

  home.stateVersion = "25.05";
}

