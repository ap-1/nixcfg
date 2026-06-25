# Theming

This config uses [Catppuccin Mocha](https://catppuccin.com/) (mauve accent) as the global theme. The preferred order is: native Catppuccin themes from [`catppuccin/nix`](https://github.com/catppuccin/nix) first, then [Stylix](https://github.com/nix-community/stylix) for what `catppuccin/nix` doesn't cover, then application-specific solutions as a last resort. Supported `catppuccin/nix` programs are added manually, i.e. with `autoEnable` off.

## Stylix

[Stylix](https://github.com/nix-community/stylix) is used for other theming needs:

- Cursor (`apple-cursor`, size 24)
- Monospace font (FiraCode Nerd Font Mono)
- Starship (`catppuccin/nix`'s starship module uses IFD via `lib.importTOML`)

## Spicetify

Spicetify uses the native Catppuccin theme bundled in [spicetify-nix](https://github.com/Gerg-L/spicetify-nix).

## Discord

Discord uses the [Catppuccin Mocha theme](https://github.com/catppuccin/discord) via Moonlight's `customCSS` extension, loaded as a CSS `@import` from `catppuccin.github.io`.

## Slack

Slack uses a 4-color Catppuccin Mocha theme string (`#1E1E2E,#CBA6F7,#A6E3A1,#EBA0AC`) [shared by sgoudham](https://github.com/catppuccin/slack/issues/10#issuecomment-2873179411), adapted for Slack's redesigned theme picker which replaced the original 10-color format.

## wl-kbptr

[wl-kbptr](https://github.com/moverest/wl-kbptr) uses a hand-mapped Catppuccin Mocha palette in its config: base and crust for backgrounds, mauve for borders, text and yellow for labels, green and red for split directions, and overlay0 for history borders.
