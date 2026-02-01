{ ... }:

{
  services.tailscale.enable = true; # for SSH
  programs.tailscale-gui.enable = true;
  programs.cloudflare-warp.enable = true;

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "tailscale-gui"
    ];
}
