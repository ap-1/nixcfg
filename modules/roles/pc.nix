{ config, ... }:
{
  flake.modules.homeManager.pc = {
    imports = with config.flake.modules.homeManager; [
      filechooser
      clipboard
      flatpak
      theme
      hyprland
      games
    ];
  };

  flake.modules.nixos.pc = {
    imports = with config.flake.modules.nixos; [
      homepage
      immich
      stashapp
      suwayomi
      vaultwarden
      openrgb
      sunshine
      games
    ];
  };
}
