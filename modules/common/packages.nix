{
  flake.modules.nixos.packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nh
        ly
        waylock
        cloudflare-warp
        ghostty.terminfo # for ssh from macbook
        wiremix # pipewire tui
        impala # iwd tui
      ];
    };

  flake.modules.darwin.packages =
    { pkgs, ... }:
    {
      environment.systemPackages = with pkgs; [
        nh
        # sunshine
        # foot.terminfo # for ssh from pc
      ];
    };

  flake.modules.homeManager.packages =
    { pkgs, lib, ... }:
    {
      home.packages =
        with pkgs;
        [
          element-desktop
          slack
          prismlauncher
          moonlight-qt
          claude-code
          jujutsu
          bitwarden-desktop
          rustup
        ]
        ++ lib.optionals stdenv.isLinux [
          foot # linux terminal emulator
          libnotify
          nerd-fonts.fira-code
          nushell # needed for xdg-desktop-portal-termfilepickers yazi wrapper scripts
        ];
    };
}
