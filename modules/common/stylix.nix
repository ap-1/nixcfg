{ inputs, ... }: {
  flake.modules.homeManager.stylix = { pkgs, lib, ... }: {
    imports = [ inputs.stylix.homeModules.stylix ];

    stylix = {
      enable = true;
      autoEnable = false;
      # inlined from tinted-theming/schemes base16/catppuccin-mocha.yaml
      base16Scheme = {
        system = "base16";
        name = "Catppuccin Mocha";
        author = "https://github.com/catppuccin/catppuccin";
        variant = "dark";
        palette = {
          base00 = "#1e1e2e";
          base01 = "#313244";
          base02 = "#45475a";
          base03 = "#6c7086";
          base04 = "#a6adc8";
          base05 = "#cdd6f4";
          base06 = "#f5e0dc";
          base07 = "#b4befe";
          base08 = "#f38ba8";
          base09 = "#fab387";
          base0A = "#f9e2af";
          base0B = "#a6e3a1";
          base0C = "#94e2d5";
          base0D = "#89b4fa";
          base0E = "#cba6f7";
          base0F = "#f2cdcd";
        };
      };
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

      targets.starship.enable = true;
    };

    # home-manager needs home.pointerCursor with explicit .enable
    home.pointerCursor.enable = lib.mkIf pkgs.stdenv.hostPlatform.isLinux true;
  };
}
