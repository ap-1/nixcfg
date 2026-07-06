{ config, ... }:
let
  meta = config.flake.meta;
  ports = config.flake.ports;
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

      mkServer =
        name:
        {
          model,
          port,
          extraFlags ? [ ],
          context ? 8192,
        }:
        {
          description = "llama.cpp ${name}";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          environment.ROCR_VISIBLE_DEVICES = "0";
          serviceConfig = {
            Type = "simple";
            DynamicUser = true;
            SupplementaryGroups = [
              "render"
              "video"
            ];
            Restart = "on-failure";
            RestartSec = 5;
            StateDirectory = "llama-server-${name}";
            ExecStart = lib.concatStringsSep " " (
              [
                "${llama-cpp}/bin/llama-server"
                "--host 127.0.0.1"
                "--port ${toString port}"
                "-hf ${model}"
                "-c ${toString context}"
                "-np 1"
              ]
              ++ extraFlags
            );
            Environment = [
              "LLAMA_CACHE=/var/lib/llama-server-${name}"
              "HOME=/var/lib/llama-server-${name}"
            ];
          };
        };
    in
    {
      age.secrets.open-webui-oauth.file = ../../secrets/open-webui-oauth.age;

      systemd.services.llama-server-chat = mkServer "chat" {
        model = "huihui-ai/Huihui-gemma-4-12B-it-qat-q4_0-unquantized-abliterated-GGUF";
        # model = "mradermacher/Qwen3.6-27B-abliterated-rMAX-GGUF:Q3_K_L";
        port = ports.llama-server-chat;
        context = 32768;
        extraFlags = [
          "--flash-attn on"
          "--cache-type-k q4_0"
        ];
      };

      systemd.services.llama-server-embeddings = mkServer "embeddings" {
        model = "gpustack/bge-m3-GGUF";
        port = ports.llama-server-embeddings;
        extraFlags = [ "--embeddings" ];
      };

      systemd.services.llama-server-reranker = mkServer "reranker" {
        model = "gpustack/bge-reranker-v2-m3-GGUF";
        port = ports.llama-server-reranker;
        extraFlags = [ "--reranking" ];
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
          OPENAI_API_BASE_URLS = "http://127.0.0.1:${toString ports.llama-server-chat}/v1;http://127.0.0.1:4000/v1";
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
