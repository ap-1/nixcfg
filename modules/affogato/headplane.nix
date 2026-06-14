{
  flake.modules.nixos.affogato-headplane =
    { config, ... }:
    {
      age.secrets.headplane-cookie-secret = {
        file = ../../secrets/headplane-cookie-secret.age;
        owner = "headplane";
        group = "headplane";
        mode = "0440";
      };

      age.secrets.headscale-api-key = {
        file = ../../secrets/headscale-api-key.age;
        owner = "headplane";
        group = "headplane";
        mode = "0440";
      };

      services.headplane = {
        enable = true;
        settings = {
          server = {
            host = "127.0.0.1";
            port = 3000;
            cookie_secret_path = config.age.secrets.headplane-cookie-secret.path;
          };

          headscale = {
            url = "http://127.0.0.1:8080";
            public_url = "https://headscale.anish.land";
            api_key_path = config.age.secrets.headscale-api-key.path;
          };

          integration.proc.enabled = true;

          oidc = {
            issuer = "https://idp.anish.land/oauth2/openid/headplane";
            client_id = "headplane";
            client_secret_path = config.age.secrets.kanidm-oauth2-headplane.path;
            redirect_uri = "https://headplane.anish.land/admin/oidc/callback";
            disable_api_key_login = true;
            headscale_api_key_path = config.age.secrets.headscale-api-key.path;
          };
        };
      };

      systemd.services.headplane = {
        wants = [ "headscale.service" ];
        after = [ "headscale.service" ];
      };
    };
}
