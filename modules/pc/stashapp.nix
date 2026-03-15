{
  flake.modules.nixos.stashapp =
    { config, ... }:
    {
      age.secrets.stash-jwt = {
        file = ../../secrets/stash-jwt.age;
        owner = "stash";
        group = "stash";
      };
      age.secrets.stash-session = {
        file = ../../secrets/stash-session.age;
        owner = "stash";
        group = "stash";
      };
      age.secrets.stash-password = {
        file = ../../secrets/stash-password.age;
        owner = "stash";
        group = "stash";
      };

      services.stash = {
        enable = true;
        openFirewall = true;
        username = "anish";
        passwordFile = config.age.secrets.stash-password.path;
        jwtSecretKeyFile = config.age.secrets.stash-jwt.path;
        sessionStoreKeyFile = config.age.secrets.stash-session.path;
        settings = {
          host = "0.0.0.0";
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
