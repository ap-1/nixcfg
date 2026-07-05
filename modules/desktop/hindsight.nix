{ inputs, ... }:
{
  flake.modules.nixos.hindsight =
    { config, ... }:
    {
      imports = [ inputs.llm-pkgs.nixosModules.hindsight ];

      services.postgresApps.hindsight.service = "hindsight";
      services.postgresql.extensions = ps: [ ps.pgvector ];

      systemd.services.hindsight-pgvector = {
        description = "Create the pgvector extension in the hindsight database";
        after = [ "postgresql.target" ];
        requires = [ "postgresql.target" ];
        before = [ "hindsight.service" ];
        wantedBy = [ "hindsight.service" ];
        serviceConfig = {
          Type = "oneshot";
          User = "postgres";
          ExecStart = ''${config.services.postgresql.package}/bin/psql -d hindsight -c "CREATE EXTENSION IF NOT EXISTS vector"'';
        };
      };

      systemd.services.hindsight = {
        after = [ "hindsight-pgvector.service" ];
        requires = [ "hindsight-pgvector.service" ];
      };

      services.hindsight = {
        enable = true;
        settings = {
          HINDSIGHT_API_DATABASE_URL = config.services.postgresApps.hindsight.url;

          # embeddings via local llama-server openai-compatible endpoint
          HINDSIGHT_API_EMBEDDINGS_PROVIDER = "openai";
          HINDSIGHT_API_EMBEDDINGS_OPENAI_BASE_URL = "http://127.0.0.1:11435/v1";
          HINDSIGHT_API_EMBEDDINGS_OPENAI_MODEL = "bge-m3";
          HINDSIGHT_API_EMBEDDINGS_OPENAI_API_KEY = "none";

          # the slim build ships no local reranker
          HINDSIGHT_API_RERANKER_PROVIDER = "none";

          # llm through the litellm proxy; set HINDSIGHT_API_LLM_MODEL and add a
          # litellm key via environmentFile once claude is wired into cliproxyapi
          HINDSIGHT_API_LLM_PROVIDER = "litellm";
          HINDSIGHT_API_LLM_BASE_URL = "http://127.0.0.1:4000";
        };
      };

      services.webProxy.sites.hindsight = "reverse_proxy http://127.0.0.1:9999";
    };
}
