{ config, ... }: {
  flake.modules.homeManager.macchiato = {
    imports = with config.flake.modules.homeManager; [
      filechooser
      theme
      hyprland
      waybar
    ];
  };

  flake.modules.nixos.macchiato = {
    imports = with config.flake.modules.nixos; [
      macchiato-configuration
      macchiato-hardware-configuration
      macchiato-networking
      filechooser
    ];
  };
}
