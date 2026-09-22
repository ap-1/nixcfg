{ inputs, ... }: {
  flake.modules.homeManager.spicetify = { pkgs, ... }: {
    imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

    programs.spicetify = {
      enable = true;
      enabledExtensions = with inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system}.extensions; [
        copyToClipboard
      ];
      alwaysEnableDevTools = true;
      theme = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system}.themes.catppuccin;
      colorScheme = "mocha";
    };
  };
}
