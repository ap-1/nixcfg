{ lib, pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages =
    with pkgs;
    [
      nh
    ]
    ++ lib.optionals stdenv.isDarwin [
      # sunshine
      # foot.terminfo # for ssh from pc
    ]
    ++ lib.optionals stdenv.isLinux [
      ly
      waylock
      cloudflare-warp
      ghostty.terminfo # for ssh from macbook
    ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "discord-canary"
      "slack"
      "claude-code"
      "cloudflare-warp"
      "tailscale-gui"
      "spotify"
      "firefox-bin"
      "firefox-bin-unwrapped"

      # pc-only
      "steam"
      "steam-unwrapped"

      # mac-only
      "shottr"
      "raycast"
    ];
}
