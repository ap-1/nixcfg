{ config, inputs, ... }:
{
  flake.modules.homeManager.desktop = {
    imports =
      (with config.flake.modules.homeManager; [
        zed-editor
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
      firefox
      localsend
      desktop-packages
      immich
      stashapp
      suwayomi
      stirling-pdf
      openrgb
      sunshine
      games
    ];
  };

  flake.modules.darwin.desktop = {
    imports = with config.flake.modules.darwin; [
      firefox
      localsend
      desktop-packages
    ];
  };
}
