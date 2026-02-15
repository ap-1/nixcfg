{ pkgs, spicetify-nix, ... }:

{
  programs.spicetify = {
    enable = true;
    enabledExtensions = with spicetify-nix.legacyPackages.${pkgs.stdenv.system}.extensions; [
      copyToClipboard
    ];
    alwaysEnableDevTools = true;
  };
}
