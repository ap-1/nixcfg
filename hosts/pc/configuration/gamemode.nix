{ ... }:

{
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };
    };
  };

  users.users.anish.extraGroups = [ "gamemode" ];
}
