{ config, ... }:
{
  flake.modules.homeManager.mocha = {
    imports = with config.flake.modules.homeManager; [
      filechooser
      clipboard
      flatpak
      theme
      hyprland
      games
      foot
    ];
  };
}
