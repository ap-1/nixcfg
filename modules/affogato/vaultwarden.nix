{
  flake.modules.nixos.affogato-vaultwarden =
    { config, ... }:
    {
      age.secrets.vaultwarden = {
        file = ../../secrets/vaultwarden.age;
        owner = "vaultwarden";
        group = "vaultwarden";
        mode = "0440";
      };

      services.vaultwarden = {
        enable = true;
        environmentFile = config.age.secrets.vaultwarden.path;
        config = {
          DOMAIN = "https://vault.anish.land";
          ROCKET_ADDRESS = "127.0.0.1";
          ROCKET_PORT = 8222;
          SIGNUPS_ALLOWED = false;

          SSO_ENABLED = true;
          SSO_ONLY = true;
          SSO_AUTHORITY = "https://idp.anish.land/oauth2/openid/vaultwarden";
          SSO_CLIENT_ID = "vaultwarden";
          SSO_PKCE = true;
          SSO_SCOPES = "openid profile email groups";
        };
      };
    };
}
