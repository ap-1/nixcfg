{ lib, pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [ nh ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "discord-canary"
      "slack"
      "claude-code"
      "cloudflare-warp"

      # mac-only
      "shottr"
      "raycast"
      "tailscale-gui"
    ];
}
