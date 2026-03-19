{
  flake.modules.nixos.vaultwarden =
    { config, ... }:
    let
      cfg = config.services.tailscale-tls;
    in
    {
      age.secrets.vaultwarden.file = ../../secrets/vaultwarden.age;

      services.tailscale-tls.proxies.vaultwarden = {
        port = 18222;
        https = 8222;
      };

      services.vaultwarden = {
        enable = true;
        environmentFile = config.age.secrets.vaultwarden.path;
        config = {
          DOMAIN = "https://${cfg.hostname}.${cfg.tailnet}:8222";
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 18222;
          SIGNUPS_ALLOWED = false;
        };
      };
    };
}
