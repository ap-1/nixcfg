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
      ghostty.terminfo # for tailscale ssh
      foot.terminfo
    ]
    ++ lib.optionals stdenv.isLinux [
      ly
      cloudflare-warp
    ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "discord-canary"
      "slack"
      "claude-code"
      "cloudflare-warp"
      "spotify"

      # mac-only
      "shottr"
      "raycast"
      "tailscale-gui"
    ];
}
