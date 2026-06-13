{
  flake.modules.homeManager.ghostty =
    { pkgs, ... }:
    {
      programs.ghostty = {
        enable = true;
        package = pkgs.ghostty-bin;
        settings = {
          window-decoration = true;
          background-blur-radius = 20;
          background-opacity = 1;
        };
      };
    };
}
