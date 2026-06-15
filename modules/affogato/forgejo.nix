{
  flake.modules.nixos.affogato-forgejo =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      age.secrets.forgejo-oauth2-secret = {
        file = ../../secrets/kanidm-oauth2-forgejo.age;
        owner = "forgejo";
        group = "forgejo";
        mode = "0440";
      };

      services.forgejo = {
        enable = true;
        settings = {
          DEFAULT.APP_NAME = "Forgejo";

          server = {
            DOMAIN = "git.anish.land";
            ROOT_URL = "https://git.anish.land/";
            HTTP_ADDR = "127.0.0.1";
            HTTP_PORT = 3001;
          };

          service = {
            DISABLE_REGISTRATION = true;
            ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
          };

          oauth2_client = {
            OPENID_CONNECT_SCOPES = "email profile";
            UPDATE_AVATAR = true;
          };

          openid = {
            ENABLE_OPENID_SIGNIN = false;
          };

          session.COOKIE_SECURE = true;
        };
      };

      systemd.tmpfiles.rules = [
        "d /var/lib/forgejo/custom 0750 forgejo forgejo -"
      ];

      systemd.services.forgejo = {
        wants = [
          "kanidm.service"
          "caddy.service"
          "network-online.target"
        ];
        after = [
          "kanidm.service"
          "caddy.service"
          "network-online.target"
        ];

        # OIDC client secret for the sandboxed unit
        serviceConfig.LoadCredential = lib.mkAfter [
          "forgejo-oauth2:${config.age.secrets.forgejo-oauth2-secret.path}"
        ];

        # Provision the kanidm login source before startup
        preStart = lib.mkAfter ''
          if ! ${config.services.forgejo.package}/bin/forgejo admin auth list \
            | ${pkgs.gnugrep}/bin/grep -qw kanidm; then
            ${config.services.forgejo.package}/bin/forgejo admin auth add-oauth \
              --name kanidm \
              --provider openidConnect \
              --key forgejo \
              --secret "$(cat "$CREDENTIALS_DIRECTORY/forgejo-oauth2")" \
              --auto-discover-url https://idp.anish.land/oauth2/openid/forgejo/.well-known/openid-configuration \
              --skip-local-2fa
          fi
        '';
      };
    };
}
