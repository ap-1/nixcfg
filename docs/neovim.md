# Neovim

Plugins are managed by Neovim 0.12's built-in [`vim.pack`](https://neovim.io/doc/user/pack/). Completion, diagnostics, and navigation come from the native LSP client, with servers installed through Nix.

## Linting

[nvim-lint](https://github.com/mfussenegger/nvim-lint) adds standalone linters for checks the language servers don't cover, such as Nix antipatterns and Markdown or YAML style.

## Formatting

Formatting is handled by the language server and triggered by a keybind.
