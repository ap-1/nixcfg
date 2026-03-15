{
  flake.modules.nixos.stashapp =
    { config, ... }:
    {
      age.secrets.stash-jwt.file = ../../secrets/stash-jwt.age;
      age.secrets.stash-session.file = ../../secrets/stash-session.age;

      services.stash = {
        enable = true;
        openFirewall = true;
        jwtSecretKeyFile = config.age.secrets.stash-jwt.path;
        sessionStoreKeyFile = config.age.secrets.stash-session.path;
        settings = {
          host = "127.0.0.1";
          port = 9999;
          stash = [
            { path = "/media/stash"; }
          ];
        };
      };

      users.users.stash.extraGroups = [ "media" ];

      systemd.tmpfiles.rules = [
        "d /media/stash 2775 root media -"
      ];
    };
}
