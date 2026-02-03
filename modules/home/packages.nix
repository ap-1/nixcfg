{ pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      discord-canary
      element-desktop
      slack
      prismlauncher
      moonlight-qt
      claude-code
      spotify
      jujutsu
    ]
    ++ lib.optionals stdenv.isLinux [
      foot # linux terminal emulator
      libnotify
      nerd-fonts.fira-code
      nushell # needed for xdg-desktop-portal-termfilepickers yazi wrapper scripts
    ];
}
