let
  devenvCaches = {
    substituters = [
      "https://devenv.cachix.org"
      "https://cachix.cachix.org"
    ];
    trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
    ];
  };
in
{
  flake.modules.nixos.nix-settings =
    {
      lib,
      pkgs,
      ...
    }:
    {
      nix.package = pkgs.lixPackageSets.stable.lix;

      nix.settings = devenvCaches;

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
          "objectbox-linux" # bluebubbles
        ];
    };

  flake.modules.darwin.nix-settings =
    {
      lib,
      pkgs,
      ...
    }:
    {
      nix.package = pkgs.lixPackageSets.stable.lix;

      nix.settings = devenvCaches;

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
    };
}
