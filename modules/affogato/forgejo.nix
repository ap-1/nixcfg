{
  flake.modules.nixos.affogato-forgejo =
    { config, pkgs, ... }:
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
            DISABLE_REGISTRATION = false;
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
        wants = [ "kanidm.service" ];
        after = [ "kanidm.service" ];
      };

      systemd.services.forgejo-oidc-setup = let
        cfg = config.services.forgejo;
        exe = "${cfg.package}/bin/forgejo";
      in {
        description = "Configure Forgejo OIDC authentication source";
        after = [ "forgejo.service" ];
        requires = [ "forgejo.service" ];
        wantedBy = [ "multi-user.target" ];
        path = [ cfg.package pkgs.git ];
        environment = {
          USER = cfg.user;
          HOME = cfg.stateDir;
          FORGEJO_WORK_DIR = cfg.stateDir;
          FORGEJO_CUSTOM = cfg.customDir;
        };
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          User = cfg.user;
          Group = cfg.group;
          WorkingDirectory = cfg.stateDir;
          ReadWritePaths = [ cfg.stateDir cfg.customDir ];
        };
        script = ''
          if ${exe} admin auth list | grep -q kanidm; then
            exit 0
          fi
          ${exe} admin auth add-oauth \
            --name kanidm \
            --provider openidConnect \
            --key forgejo \
            --secret "$(cat ${config.age.secrets.forgejo-oauth2-secret.path})" \
            --auto-discover-url https://idp.anish.land/oauth2/openid/forgejo/.well-known/openid-configuration \
            --skip-local-2fa true
        '';
      };
    };
}
