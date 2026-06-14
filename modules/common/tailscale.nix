{
  flake.modules.nixos.tailscale =
    { pkgs, ... }:
    {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = "both"; # IP forwarding
      };

      # Apply UDP GRO forwarding each time an interface comes up
      networking.networkmanager.dispatcherScripts = [
        {
          source = pkgs.writeScript "tailscale-udp-gro" ''
            #!${pkgs.runtimeShell}
            if [ "$2" = "up" ]; then
              ${pkgs.ethtool}/bin/ethtool -K "$1" rx-udp-gro-forwarding on rx-gro-list off 2>/dev/null || true
            fi
          '';
          type = "basic";
        }
      ];
    };

  flake.modules.darwin.tailscale = {
    services.tailscale.enable = true;
  };
}
