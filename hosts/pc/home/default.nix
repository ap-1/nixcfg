{ pkgs, ... }:

{
  imports = [
    ../../../modules/home
    ./hyprland
    ./flatpak.nix
    ./filechooser.nix
    ./theme.nix
  ];

  fonts.fontconfig.enable = true;

  programs.zsh.shellAliases.update = "nh os switch ~/nixcfg";

  # enabled manually for catppuccin
  programs.rofi.enable = true;
  services.dunst.enable = true;

  programs.foot = {
    enable = true;
    settings = {
      main = {
        font = "monospace:size=12";
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

  programs.mangohud = {
    enable = true;
    enableSessionWide = false;
    settings = {
      cpu_temp = true;
      gpu_temp = true;
      fps = true;
      frame_timing = 1;
    };
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  home.stateVersion = "25.05";
}
