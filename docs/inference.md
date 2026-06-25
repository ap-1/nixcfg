# Inference

mocha runs LLM inference through [Open WebUI](https://openwebui.com/) at `chat.ts.anish.land`, with two tailnet-only paths:

- [Ollama](https://ollama.com/) for local models on the RX 7800 XT, and
- [LiteLLM](https://litellm.ai/) -> [CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI) for cloud models via existing subscriptions.

## Ollama

Ollama runs with ROCm, pinned to the discrete GPU so the integrated GPU is masked. Flash attention and 4-bit KV cache quantisation are enabled to maximise context within 16 GB of VRAM. Models are preloaded declaratively.

## Open WebUI

[Open WebUI](https://openwebui.com/) provides a chat interface at `chat.ts.anish.land`, authenticated via kanidm OIDC. It talks to Ollama for local models and to LiteLLM for cloud models.

## LiteLLM

[LiteLLM](https://litellm.ai/) sits between Open WebUI and CLIProxyAPI for usage tracking in PostgreSQL. It also provides an admin UI at `litellm.ts.anish.land` with kanidm OIDC.

The NixOS module comes from [`litellm-nix`](https://codeberg.org/anish/litellm-nix), which exists because LiteLLM's database-backed proxy mode needs a Prisma client generated against its schema. The nixpkgs package [cannot do this](https://github.com/NixOS/nixpkgs/issues/432925) in the sandbox; `litellm-nix` builds the client in the derivation instead.

## CLIProxyAPI

[CLIProxyAPI](https://github.com/router-for-me/CLIProxyAPI) is the upstream that LiteLLM routes to. It wraps CLI-based AI subscriptions (Claude Code, Gemini CLI, Codex, and others) as OpenAI-compatible API endpoints using their existing OAuth sessions, avoiding separate API billing.

## Oh My Pi

[Oh My Pi](https://ohmypi.dev/) is a coding agent harness, packaged for NixOS/nix-darwin by [`omp-nix`](https://git.molez.org/mandlm/omp-nix) and installed on desktop hosts. It connects to LiteLLM for cloud model access.
