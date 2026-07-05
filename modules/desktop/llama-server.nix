{ config, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.nixos.llamaServer =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    let
      llama-cpp = pkgs.llama-cpp-rocm;

      chatModel = "huihui-ai/Huihui-gemma-4-12B-it-qat-q4_0-unquantized-abliterated-GGUF";
      # chatModel = "mradermacher/Qwen3.6-27B-abliterated-rMAX-GGUF:Q3_K_L";

      embeddingsModel = "gpustack/bge-m3-GGUF";

      chatPort = 11434;
      embeddingsPort = 11435;

      commonEnv = {
        # pin to the 7800 xt (gfx1101), mask the igpu (gfx1036)
        ROCR_VISIBLE_DEVICES = "0";
      };

      commonServiceConfig = {
        Type = "simple";
        DynamicUser = true;
        SupplementaryGroups = [
          "render"
          "video"
        ];
        Restart = "on-failure";
        RestartSec = 5;
      };
    in
    {
      age.secrets.open-webui-oauth.file = ../../secrets/open-webui-oauth.age;

      systemd.services.llama-server-chat = {
        description = "llama.cpp chat model";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = commonEnv;
        serviceConfig = commonServiceConfig // {
          StateDirectory = "llama-server-chat";
          ExecStart = lib.concatStringsSep " " [
            "${llama-cpp}/bin/llama-server"
            "--host 127.0.0.1"
            "--port ${toString chatPort}"
            "-hf ${chatModel}"
            "--flash-attn on"
            "--cache-type-k q4_0"
            "-c 32768"
            "-np 1"
          ];
          Environment = [
            "LLAMA_CACHE=/var/lib/llama-server-chat"
            "HOME=/var/lib/llama-server-chat"
          ];
        };
      };

      systemd.services.llama-server-embeddings = {
        description = "llama.cpp embeddings (bge-m3)";
        after = [ "network.target" ];
        wantedBy = [ "multi-user.target" ];
        environment = commonEnv;
        serviceConfig = commonServiceConfig // {
          StateDirectory = "llama-server-embeddings";
          ExecStart = lib.concatStringsSep " " [
            "${llama-cpp}/bin/llama-server"
            "--host 127.0.0.1"
            "--port ${toString embeddingsPort}"
            "-hf ${embeddingsModel}"
            "--embeddings"
            "-c 8192"
            "-np 1"
          ];
          Environment = [
            "LLAMA_CACHE=/var/lib/llama-server-embeddings"
            "HOME=/var/lib/llama-server-embeddings"
          ];
        };
      };

      services.open-webui = {
        enable = true;
        host = "127.0.0.1";
        port = 3000;
        environmentFile = config.age.secrets.open-webui-oauth.path;
        environment = {
          HOME = "/var/lib/open-webui";
          ENABLE_OLLAMA_API = "False";
          ENABLE_OPENAI_API = "True";
          OPENAI_API_BASE_URLS = "http://127.0.0.1:${toString chatPort}/v1;http://127.0.0.1:4000/v1";
          OPENAI_API_KEYS = "none;unused";
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
