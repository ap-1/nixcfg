{ config, ... }:
{
  flake.modules.homeManager.mocha = {
    imports = with config.flake.modules.homeManager; [
      filechooser
      flatpak
      theme
      hyprland
      games
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
