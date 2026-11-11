{
  config,
  inputs,
  ...
}:
{
  flake.modules.homeManager.desktop = { pkgs, ... }: {
    imports = with config.flake.modules.homeManager; [
      zed-editor
      firefox
      spicetify
      discord
      desktop-packages
      moonlight
      omp
    ];

    home.packages = [ inputs.autolith.packages.${pkgs.stdenv.hostPlatform.system}.default ];
  };

  flake.modules.nixos.desktop = {
    imports = with config.flake.modules.nixos; [
      firefox
      desktop-packages
      hyprland
      wireless
      moonlight
      umvpn
      bootvine
      omp
    ];

    time.timeZone = "America/New_York";
    programs.nix-ld.enable = true;
  };

  flake.modules.darwin.desktop = {
    imports = with config.flake.modules.darwin; [
      firefox
      desktop-packages
      umvpn
    ];
  };
}
