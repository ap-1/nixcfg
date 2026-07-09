{
  flake.modules.nixos.desktop-packages = { pkgs, ... }: {
    nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];

    environment.systemPackages = with pkgs; [
      ly
      waylock
      cloudflare-warp
      wiremix # pipewire tui
      impala # iwd tui
      librepods
    ];
  };

  flake.modules.darwin.desktop-packages = { pkgs, ... }: {
    nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];

    environment.systemPackages = with pkgs; [
      darwin.PowerManagement
    ];
  };

  flake.modules.homeManager.desktop-packages =
    {
      pkgs,
      lib,
      ...
    }:
    {
      home.packages =
        with pkgs;
        [
          element-desktop
          signal-desktop
          slack
          jujutsu
          bitwarden-desktop
          rustup
        ]
        ++ lib.optionals stdenv.isLinux [
          bluebubbles
          prismlauncher
          foot # linux terminal emulator
          libnotify
          nerd-fonts.fira-code
          nushell # needed for xdg-desktop-portal-termfilepickers yazi wrapper scripts
          wl-clipboard
          cliphist
          wl-kbptr
          wlrctl
          ydotool
        ];
    };
}
