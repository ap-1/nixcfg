# Inference

mocha runs LLM inference through [Open WebUI](https://openwebui.com/) at `chat.ts.anish.land`, with two tailnet-only paths:

- [llama.cpp](https://github.com/ggml-org/llama.cpp) (`llama-server`) for local models on the RX 7800 XT, and
- [LiteLLM](https://litellm.ai/) -> [CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI) for cloud models via existing subscriptions.

## llama-server

Three `llama-server` instances (from the `llama-cpp-rocm` package) run on the discrete GPU, with the iGPU masked via `ROCR_VISIBLE_DEVICES`. One serves the chat model with flash attention and q4_0 KV cache to fit 32k context in 16 GB VRAM. The other two serve bge-m3 embeddings and bge-reranker-v2-m3 reranking for Hindsight.

## Open WebUI

[Open WebUI](https://openwebui.com/) provides a chat interface at `chat.ts.anish.land`, authenticated via kanidm OIDC. It talks to llama-server for local models and to LiteLLM for cloud models.

## Hindsight

[Hindsight](https://github.com/vectorize-io/hindsight) provides persistent agent memory backed by pgvector in PostgreSQL. It uses dedicated llama-server instances for bge-m3 embeddings and bge-reranker-v2-m3 reranking, and routes LLM queries through LiteLLM. The NixOS module comes from `llm-pkgs`.

## LiteLLM

[LiteLLM](https://litellm.ai/) sits between Open WebUI and CLIProxyAPI for usage tracking in PostgreSQL. It also provides an admin UI at `litellm.ts.anish.land` with kanidm OIDC.

The NixOS module comes from [`llm-pkgs`](https://codeberg.org/anish/llm-pkgs), which exists because LiteLLM's database-backed proxy mode needs a Prisma client generated against its schema. The nixpkgs package [cannot do this](https://github.com/NixOS/nixpkgs/issues/432925) in the sandbox; `llm-pkgs` builds the client in the derivation instead.

## CLIProxyAPI

[CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI) is the upstream that LiteLLM routes to. It wraps CLI-based AI subscriptions (Claude Code, Gemini CLI, Codex, and others) as OpenAI-compatible API endpoints using their existing OAuth sessions, avoiding separate API billing.

## Oh My Pi

[Oh My Pi](https://ohmypi.dev/) is a coding agent harness, packaged for NixOS/nix-darwin by [`omp-nix`](https://git.molez.org/mandlm/omp-nix) and installed on desktop hosts. It connects to LiteLLM for cloud model access.
