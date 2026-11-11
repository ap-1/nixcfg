{
  flake.modules.nixos.stashapp = { config, pkgs, ... }: {
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

    services.webProxy.sites.stash = "reverse_proxy http://127.0.0.1:19999";

    services.stash = {
      enable = true;
      # TODO: https://github.com/NixOS/nixpkgs/pull/586418
      package = (pkgs.stash.override { buildGoModule = pkgs.buildGo126Module; }).overrideAttrs {
        preConfigure = ''
          export HOME=$(mktemp -d)
        '';
      };
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
