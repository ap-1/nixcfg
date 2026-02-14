{
  lib,
  pkgs,
  isLinux,
  ...
}:

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
      wiremix # pipewire tui
      impala # iwd tui
    ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "discord-canary"
      "slack"
      "claude-code"
      "cloudflare-warp"
      "tailscale-gui"
      "firefox-bin"
      "firefox-bin-unwrapped"
      "apple_cursor"
      "spotify"

      # pc-only
      "steam"
      "steam-unwrapped"
      "tetrio-desktop"

      # mac-only
      "shottr"
      "raycast"
    ];
}
// lib.optionalAttrs (!isLinux) {
  determinateNix.customSettings = {
    trusted-users = [ "anish" ];
    extra-substituters = [ "https://cache.garnix.io" ];
    extra-trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
  };
}
