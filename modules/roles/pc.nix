{ config, ... }:
{
  flake.modules.homeManager.pc = {
    imports = with config.flake.modules.homeManager; [
      filechooser
      clipboard
      flatpak
      theme
    ];
  };

  flake.modules.nixos.pc = {
    imports = [
    ];
  };
}
