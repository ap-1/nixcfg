{ pkgs, ... }:

{
  home.packages =
    with pkgs;
    [
      claude-code
      discord-canary
      slack
      prismlauncher
      moonlight-qt
      qbittorrent
      element-desktop
      spotify
    ]
    ++ lib.optionals stdenv.isDarwin [
      ghostty-bin
    ]
    ++ lib.optionals stdenv.isLinux [
      ghostty
      libnotify
      nerd-fonts.fira-code
      nushell # needed for xdg-desktop-portal-termfilepickers yazi wrapper scripts
    ];
}
