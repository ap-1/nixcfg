{
  flake.modules.nixos.affogato-kanidm =
    { config, pkgs, ... }:
    {
      age.secrets.kanidm-admin = {
        file = ../../secrets/kanidm-admin.age;
        owner = "kanidm";
        group = "kanidm";
        mode = "0440";
      };
      age.secrets.kanidm-idm-admin = {
        file = ../../secrets/kanidm-idm-admin.age;
        owner = "kanidm";
        group = "kanidm";
        mode = "0440";
      };
      age.secrets.kanidm-oauth2-headscale = {
        file = ../../secrets/kanidm-oauth2-headscale.age;
        owner = "kanidm";
        group = "kanidm";
        mode = "0440";
      };
      age.secrets.kanidm-oauth2-headplane = {
        file = ../../secrets/kanidm-oauth2-headplane.age;
        owner = "kanidm";
        group = "kanidm";
        mode = "0440";
      };

      users.users.kanidm.extraGroups = [ "caddy" ];

      services.kanidm = {
        package = pkgs.kanidmWithSecretProvisioning_1_10;

        server.enable = true;
        server.settings = {
          domain = "idp.anish.land";
          origin = "https://idp.anish.land";
          bindaddress = "127.0.0.1:8443";
          tls_chain = "/var/lib/acme/idp.anish.land/fullchain.pem";
          tls_key = "/var/lib/acme/idp.anish.land/key.pem";
          online_backup = {
            path = "/var/lib/kanidm/backups";
            schedule = "00 22 * * *";
            versions = 7;
          };
        };

        client.enable = true;
        client.settings.uri = "https://idp.anish.land";

        provision = {
          enable = true;
          adminPasswordFile = config.age.secrets.kanidm-admin.path;
          idmAdminPasswordFile = config.age.secrets.kanidm-idm-admin.path;
          autoRemove = true;

          groups."headscale.access" = { };
          groups."headplane.admins" = { };

          persons.anish = {
            displayName = "Anish";
            mailAddresses = [ "i@anish.land" ];
            groups = [
              "headscale.access"
              "headplane.admins"
            ];
          };

          systems.oauth2.headscale = {
            displayName = "Headscale";
            originUrl = "https://headscale.anish.land/oidc/callback";
            originLanding = "https://headscale.anish.land/";
            basicSecretFile = config.age.secrets.kanidm-oauth2-headscale.path;
            preferShortUsername = true;
            scopeMaps."headscale.access" = [
              "openid"
              "profile"
              "email"
              "groups"
            ];
          };

          systems.oauth2.headplane = {
            displayName = "Headplane";
            originUrl = "https://headplane.anish.land/admin/oidc/callback";
            originLanding = "https://headplane.anish.land/";
            basicSecretFile = config.age.secrets.kanidm-oauth2-headplane.path;
            preferShortUsername = true;
            scopeMaps."headplane.admins" = [
              "openid"
              "profile"
              "email"
              "groups"
            ];
          };
        };
      };

      security.acme.certs."idp.anish.land".reloadServices = [ "kanidm.service" ];

      systemd.services.kanidm = {
        wants = [ "acme-order-renew-idp.anish.land.service" ];
        after = [ "acme-order-renew-idp.anish.land.service" ];
      };
    };
}
