{
  flake.modules.nixos.nix-settings =
    { lib, ... }:
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
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
          "steam"
          "steam-unwrapped"
          "tetrio-desktop"
        ];
    };

  flake.modules.darwin.nix-settings =
    { lib, ... }:
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
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
          "shottr"
          "raycast"
        ];

      determinateNix.customSettings = {
        trusted-users = [ "anish" ];
        extra-substituters = [ "https://cache.garnix.io" ];
        extra-trusted-public-keys = [ "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g=" ];
      };
    };
}
