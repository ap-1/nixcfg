{ lib, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "discord-canary"
    "slack"
    "claude-code"
    
    # mac-only
    "shottr"
    "raycast"
  ];
}
