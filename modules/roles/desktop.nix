{
  config,
  inputs,
  ...
}:
{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    imports =
      (with config.flake.modules.homeManager; [
        zed-editor
        firefox
        spicetify
        discord
        desktop-packages
        moonlight
      ])
      ++ [
        inputs.oh-my-pi.homeManagerModules.default
      ];

    programs.omp = {
      enable = true;
      package = pkgs.omp;
      settings = {
        setupVersion = 1;
        theme.dark = "dark-catppuccin";
        computer.enabled = true;
      };
    };

    home.packages = [ inputs.autolith.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };

  flake.modules.nixos.desktop = {
    imports = with config.flake.modules.nixos; [
      firefox
      localsend
      desktop-packages
      hyprland
      immich
      stashapp
      suwayomi
      llamaServer
      litellm
      cliproxyapi
      hindsight
      postgres
      hardware-control
      sunshine
      moonlight
      games
      umvpn
      openwhispr
      bootvine
    ];
  };

  flake.modules.darwin.desktop = {
    imports = with config.flake.modules.darwin; [
      firefox
      localsend
      desktop-packages
      sunshine
      umvpn
    ];
  };
}
