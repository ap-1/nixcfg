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

      services.tailscale-tls.proxies.stashapp = {
        port = 19999;
        https = 9999;
      };

      services.stash = {
        enable = true;
        mutableSettings = false;
        username = "anish";
        passwordFile = config.age.secrets.stash-password.path;
        jwtSecretKeyFile = config.age.secrets.stash-jwt.path;
        sessionStoreKeyFile = config.age.secrets.stash-session.path;
        settings = {
          host = "127.0.0.1";
          port = 19999;
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
