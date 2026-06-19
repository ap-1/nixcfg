{
  flake.modules.nixos.desktop-packages =
    { pkgs, ... }:
    {
      nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];

      # patch wlrctl scroll to use WHEEL axis source
      nixpkgs.overlays = [
        (final: prev: {
          wlrctl = prev.wlrctl.overrideAttrs (old: {
            postPatch = (old.postPatch or "") + ''
              substituteInPlace pointer.c \
                --replace-fail 'WL_POINTER_AXIS_SOURCE_FINGER' 'WL_POINTER_AXIS_SOURCE_WHEEL'
            '';
          });
        })
      ];

      environment.systemPackages = with pkgs; [
        ly
        waylock
        cloudflare-warp
        wiremix # pipewire tui
        impala # iwd tui
        librepods
        playerctl
      ];
    };

  flake.modules.darwin.desktop-packages =
    { pkgs, ... }:
    {
      nixpkgs.config.permittedInsecurePackages = [ "electron-39.8.10" ];

      environment.systemPackages = with pkgs; [
        darwin.PowerManagement
      ];
    };

  flake.modules.homeManager.desktop-packages =
    { pkgs, lib, ... }:
    {
      home.packages =
        with pkgs;
        [
          tetrio-desktop
          # element-desktop
          slack
          jujutsu
          bitwarden-desktop
          rustup
        ]
        ++ lib.optionals stdenv.isLinux [
          prismlauncher
          foot # linux terminal emulator
          libnotify
          nerd-fonts.fira-code
          nushell # needed for xdg-desktop-portal-termfilepickers yazi wrapper scripts
          wl-clipboard
          cliphist
          wl-kbptr
          wlrctl
        ];
    };
}
