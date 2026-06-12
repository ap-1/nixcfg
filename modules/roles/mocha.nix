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

  flake.modules.nixos.mocha = {
    imports = with config.flake.modules.nixos; [
      mocha-configuration
      mocha-hardware-configuration
      media-server
      cachyos-kernel
    ];
  };
}
