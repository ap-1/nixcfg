{ config, ... }:

{
  imports = [ ./tailscale-serve.nix ];

  services.tailscale-serve.vault = {
    port = 8222;
    https = 8222;
  };

  age.secrets.vaultwarden.file = ../../../secrets/vaultwarden.age;

  services.vaultwarden = {
    enable = true;
    environmentFile = config.age.secrets.vaultwarden.path;
    config = {
      DOMAIN = "https://pc.meteor-banjo.ts.net:8222";
      ROCKET_ADDRESS = "127.0.0.1";
      ROCKET_PORT = 8222;
      SIGNUPS_ALLOWED = true;
    };
  };
}
