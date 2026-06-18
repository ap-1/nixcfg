{ config, inputs, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.nixos.litellm =
    { config, ... }:
    {
      imports = [ inputs.litellm-nix.nixosModules.default ];

      age.secrets.litellm-env.file = ../../secrets/litellm-env.age;

      services.postgresApps.litellm.service = "litellm";

      services.litellm = {
        enable = true;
        host = "127.0.0.1";
        port = 4000;
        environmentFile = config.age.secrets.litellm-env.path;
        environment = {
          DATABASE_URL = config.services.postgresApps.litellm.url;
          PROXY_BASE_URL = "https://litellm.${meta.tailnetDomain}";
          GENERIC_CLIENT_ID = "litellm";
          GENERIC_AUTHORIZATION_ENDPOINT = "${meta.idpUrl}/ui/oauth2";
          GENERIC_TOKEN_ENDPOINT = "${meta.idpUrl}/oauth2/token";
          GENERIC_USERINFO_ENDPOINT = "${meta.idpUrl}/oauth2/openid/litellm/userinfo";
          GENERIC_CLIENT_USE_PKCE = "true";
          GENERIC_SCOPE = "openid email profile groups";
          GENERIC_USER_ID_ATTRIBUTE = "sub";
          GENERIC_USER_EMAIL_ATTRIBUTE = "email";
          GENERIC_USER_DISPLAY_NAME_ATTRIBUTE = "name";
          GENERIC_USER_ROLE_ATTRIBUTE = "litellm_role";
          AUTO_REDIRECT_UI_LOGIN_TO_SSO = "true";
        };
        settings.general_settings.store_model_in_db = true;
      };

      services.webProxy.sites.litellm = ''
        redir / /ui/
        reverse_proxy http://127.0.0.1:4000
      '';
    };
}
