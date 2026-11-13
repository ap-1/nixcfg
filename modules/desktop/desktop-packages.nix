{
  flake.modules.nixos.desktop-packages = { pkgs, ... }: {
    nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];

    environment.systemPackages = with pkgs; [
      wiremix # pipewire tui
      impala # iwd tui
      bluetui
      librepods
      bitwarden-desktop
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
          (
            # electron doesn't detect oo7 under hyprland
            if stdenv.hostPlatform.isLinux then
              symlinkJoin {
                inherit (element-desktop) name meta;
                paths = [ element-desktop ];
                nativeBuildInputs = [ makeWrapper ];
                postBuild = ''
                  wrapProgram $out/bin/element-desktop --add-flags --password-store=gnome-libsecret
                '';
              }
            else
              element-desktop
          )
          signal-desktop
          jujutsu
          rustup
          elan
        ]
        ++ lib.optionals (lib.meta.availableOn stdenv.hostPlatform slack) [
          slack
        ]
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          bitwarden-desktop
        ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [
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
