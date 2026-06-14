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
      age.secrets.kanidm-oauth2-vaultwarden = {
        file = ../../secrets/kanidm-oauth2-vaultwarden.age;
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
          groups."vaultwarden.access" = { };

          persons.anish = {
            displayName = "Anish";
            mailAddresses = [ "i@anish.land" ];
            groups = [
              "headscale.access"
              "headplane.admins"
              "vaultwarden.access"
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

          systems.oauth2.vaultwarden = {
            displayName = "Vaultwarden";
            originUrl = "https://vault.anish.land/identity/connect/oidc-signin";
            originLanding = "https://vault.anish.land/";
            basicSecretFile = config.age.secrets.kanidm-oauth2-vaultwarden.path;
            preferShortUsername = true;
            scopeMaps."vaultwarden.access" = [
              "openid"
              "profile"
              "email"
              "groups"
            ];
          };
        };
      };

      security.acme.certs."idp.anish.land".reloadServices = [ "kanidm.service" ];

      systemd.tmpfiles.rules = [
        "d /var/lib/kanidm/backups 0700 kanidm kanidm -"
      ];

      systemd.services.kanidm = {
        wants = [ "acme-idp.anish.land.service" ];
        after = [ "acme-idp.anish.land.service" ];
      };
    };
}
