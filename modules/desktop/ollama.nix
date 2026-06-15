{
  flake.modules.nixos.ollama = {
    services.ollama = {
      enable = true;
      acceleration = "rocm";
      environmentVariables = {
        # pin to the 7800 xt (gfx1101), mask the igpu (gfx1036)
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
      host = "0.0.0.0";
      port = 3000;
      environment = {
        OLLAMA_BASE_URL = "http://127.0.0.1:11434";
        WEBUI_AUTH = "False";
      };
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 3000 ];
  };
}
