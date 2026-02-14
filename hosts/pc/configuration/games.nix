{ pkgs, lib, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    extraCompatPackages = with pkgs; [
      proton-ge-bin
      mangohud
    ];
  };

  # Native games
  environment.systemPackages = with pkgs; [ tetrio-desktop ];

  # Gamemode
  programs.gamemode.enable = true;

  users.users.anish.extraGroups = [ "gamemode" ];
}
