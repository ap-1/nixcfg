{ config, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.nixos.tailscale =
    { pkgs, ... }:
    {
      services.tailscale = {
        enable = true;
        useRoutingFeatures = "both"; # IP forwarding
        extraUpFlags = [
          "--login-server=https://headscale.${meta.domain}"
          "--ssh"
          "--advertise-exit-node"
        ];
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
    # macOS MagicDNS resolver for the headscale tailnet
    environment.etc."resolver/${meta.tailnetDomain}".text = "nameserver 100.100.100.100";
  };
}
