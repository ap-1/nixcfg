# Theming

This config uses [Catppuccin Mocha](https://catppuccin.com/) as the global theme. We opt for native Catppuccin themes from [`catppuccin/nix`](https://github.com/catppuccin/nix) when applicable. Supported programs are added manually, i.e. with `autoEnable` off.

## Stylix

[Stylix](https://github.com/nix-community/stylix) is used for other theming needs:

- Cursor (`apple-cursor`, size 24)
- Monospace font (FiraCode Nerd Font Mono)
- Starship (`catppuccin/nix`'s starship module uses IFD via `lib.importTOML`)

## Spicetify

Spicetify uses the native Catppuccin theme bundled in [spicetify-nix](https://github.com/Gerg-L/spicetify-nix).
