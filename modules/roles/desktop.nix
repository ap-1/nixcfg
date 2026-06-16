{ config, inputs, ... }:
{
  flake.modules.homeManager.desktop = {
    imports =
      (with config.flake.modules.homeManager; [
        zed-editor
        firefox
        spicetify
        discord
        desktop-packages
        sunshine
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
      # stirling-pdf # libreoffice not cached upstream yet
      ollama
      litellm
      postgres
      hardware-control
      sunshine
      games
    ];
  };

  flake.modules.darwin.desktop = {
    imports = with config.flake.modules.darwin; [
      firefox
      localsend
      desktop-packages
      sunshine
    ];
  };
}
