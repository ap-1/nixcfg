{ config, inputs, ... }:
{
  flake.modules.homeManager.desktop = {
    imports =
      (with config.flake.modules.homeManager; [
        zed-editor
        stylix
        catppuccin
        firefox
        spicetify
        discord
        syncthing
        desktop-packages
      ])
      ++ [
        inputs.omp-nix.homeManagerModules.omp
      ];

    oh-my-pi.enable = true;
  };

  flake.modules.nixos.desktop = {
    imports = with config.flake.modules.nixos; [
      localsend
      desktop-packages
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

  flake.modules.darwin.desktop = {
    imports = with config.flake.modules.darwin; [
      localsend
      desktop-packages
    ];
  };
}
