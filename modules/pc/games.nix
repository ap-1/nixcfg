{
  flake.modules.nixos.games =
    { pkgs, ... }:
    {
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        localNetworkGameTransfers.openFirewall = true;
        gamescopeSession.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
          mangohud
        ];
      };

      # Native games
      environment.systemPackages = with pkgs; [
        tetrio-desktop
        (heroic.override {
          extraPkgs = pkgs': with pkgs'; [
            gamescope
            gamemode
          ];
        })
      ];

      # Gamescope
      programs.gamescope = {
        enable = true;
        capSysNice = true;
        args = [
          "--rt"
          "--expose-wayland"
        ];
      };

      # Gamemode
      programs.gamemode.enable = true;

      users.users.anish.extraGroups = [ "gamemode" ];
    };
}
