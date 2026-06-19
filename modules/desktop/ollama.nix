{ config, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.nixos.ollama =
    { config, pkgs, ... }:
    {
      age.secrets.open-webui-oauth.file = ../../secrets/open-webui-oauth.age;

      services.ollama = {
        enable = true;
        package = pkgs.ollama-rocm;
        environmentVariables = {
          # pin to the 7800 xt (gfx1101); mask the igpu (gfx1036)
          ROCR_VISIBLE_DEVICES = "0";
          OLLAMA_FLASH_ATTENTION = "1";
          OLLAMA_KV_CACHE_TYPE = "q8_0";
          OLLAMA_CONTEXT_LENGTH = "8192";
          OLLAMA_MAX_LOADED_MODELS = "1";
          OLLAMA_NUM_PARALLEL = "1";
        };
      };

      services.open-webui = {
        enable = true;
        host = "127.0.0.1";
        port = 3000;
        environmentFile = config.age.secrets.open-webui-oauth.path;
        environment = {
          HOME = "/var/lib/open-webui";
          OLLAMA_BASE_URL = "http://127.0.0.1:11434";
          ENABLE_OPENAI_API = "True";
          OPENAI_API_BASE_URL = "http://127.0.0.1:4000/v1";
          WEBUI_URL = "https://chat.${meta.tailnetDomain}";
          ENABLE_OAUTH_SIGNUP = "True";
          OAUTH_PROVIDER_NAME = "Kanidm";
          OAUTH_CLIENT_ID = "open-webui";
          OAUTH_SCOPES = "openid email profile";
          OPENID_PROVIDER_URL = "${meta.idpUrl}/oauth2/openid/open-webui/.well-known/openid-configuration";
          OAUTH_CODE_CHALLENGE_METHOD = "S256";
        };
      };

      services.webProxy.sites.chat = "reverse_proxy http://127.0.0.1:3000";
    };
}
