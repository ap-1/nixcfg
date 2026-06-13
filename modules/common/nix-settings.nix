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
          "cloudflare-warp"
          "firefox-bin"
          "firefox-bin-unwrapped"
          "enhancer-for-youtube"
          "pay-by-privacy"
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
          "cloudflare-warp"
          "tailscale-gui"
          "firefox-bin"
          "firefox-bin-unwrapped"
          "enhancer-for-youtube"
          "pay-by-privacy"
          "apple_cursor"
          "spotify"
          "shottr"
          "tetrio-desktop"
        ];

      determinateNix.customSettings = {
        trusted-users = [ "anish" ];
        lazy-trees = true;
      };
    };
}
