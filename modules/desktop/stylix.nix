{ inputs, ... }:
{
  flake.modules.homeManager.stylix =
    { pkgs, ... }:
    {
      imports = [ inputs.stylix.homeModules.stylix ];

      stylix = {
        enable = true;
        autoEnable = false;
        base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        polarity = "dark";
        cursor = {
          package = pkgs.apple-cursor;
          name = "macOS";
          size = 24;
        };
      };
    };
}
