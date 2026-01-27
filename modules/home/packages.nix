{ pkgs, ... }:

{
  home.packages = with pkgs; [
    claude-code
    discord-canary
    slack
    prismlauncher
    moonlight-qt
    qbittorrent
    element-desktop
  ];
}
