{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

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
    shellWrapperName = "y";

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

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    setSessionVariables = true;
  };

  home.stateVersion = "25.05";
}
