{ config, ... }:
{
  flake.modules.homeManager.pc = {
    imports = with config.flake.modules.homeManager; [
      filechooser
      clipboard
      flatpak
      theme
      hyprland
    ];
  };

  flake.modules.nixos.pc = {
    imports = with config.flake.modules.nixos; [
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
