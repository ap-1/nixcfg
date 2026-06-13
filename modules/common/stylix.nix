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

        fonts.monospace = {
          package = pkgs.nerd-fonts.fira-code;
          name = "FiraCode Nerd Font Mono";
        };

        targets = {
          bat.enable = true;
          dunst.enable = true;
          foot.enable = true;
          ghostty.enable = true;
          hyprland.enable = true;
          mangohud.enable = true;
          neovim.enable = true;
          rofi.enable = true;
          starship.enable = true;
          tmux.enable = true;
          vivid.enable = true;
          yazi.enable = true;
          zed.enable = true;
          zellij.enable = true;
        };
      };
    };
}
