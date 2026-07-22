{ inputs, ... }: {
  flake.modules.homeManager.stylix = { pkgs, lib, ... }: {
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

      targets.starship.enable = true;
    };

    # home-manager needs home.pointerCursor with explicit .enable
    home.pointerCursor.enable = lib.mkIf pkgs.stdenv.hostPlatform.isLinux true;
  };
}
