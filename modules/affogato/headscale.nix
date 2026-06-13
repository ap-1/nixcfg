{
  flake.modules.nixos.affogato-headscale =
    { config, ... }:
    {
      age.secrets.headscale-oidc = {
        file = ../../secrets/kanidm-oauth2-headscale.age;
        owner = "headscale";
        group = "headscale";
        mode = "0440";
      };

      services.headscale = {
        enable = true;
        address = "127.0.0.1";
        port = 8080;
        settings = {
          server_url = "https://headscale.anish.land";

          dns = {
            magic_dns = true;
            base_domain = "ts.anish.land";
            override_local_dns = false;
          };

          oidc = {
            issuer = "https://idp.anish.land/oauth2/openid/headscale";
            client_id = "headscale";
            client_secret_path = config.age.secrets.headscale-oidc.path;
            scope = [
              "openid"
              "profile"
              "email"
              "groups"
            ];
            pkce.enabled = true;
            allowed_groups = [ "headscale.access@idp.anish.land" ];
          };
        };
      };
    };
}
