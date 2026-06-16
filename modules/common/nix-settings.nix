{
  flake.modules.nixos.nix-settings =
    { lib, pkgs, ... }:
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.package = pkgs.lixPackageSets.stable.lix;

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
          "open-webui"
        ];
    };

  flake.modules.darwin.nix-settings =
    { lib, pkgs, ... }:
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.package = pkgs.lixPackageSets.stable.lix;

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

      nix.settings = {
        trusted-users = [ "anish" ];
      };
    };
}
