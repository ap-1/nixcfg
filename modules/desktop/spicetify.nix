{ inputs, ... }: {
  flake.modules.homeManager.spicetify = { lib, pkgs, ... }: {
    imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

    programs.spicetify = lib.mkIf (lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.spotify) {
      enable = true;
      enabledExtensions =
        with inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system}.extensions; [
          copyToClipboard
        ];
      alwaysEnableDevTools = true;
      theme = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system}.themes.catppuccin;
      colorScheme = "mocha";
    };
  };
}
