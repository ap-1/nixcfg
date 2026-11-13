# Networking

The fleet runs on a self-hosted [headscale](https://headscale.net/) control plane on affogato. Hosts connect to `https://headscale.anish.land`.

## Joining a host

NixOS hosts join with a reusable headscale pre-auth key. Tailscale flags only apply when a host authenticates. Logging out with `tailscale logout` and restarting `tailscaled-autoconnect` makes it authenticate again.

Keys are minted on affogato:

```
sudo headscale preauthkeys create --user <id> --reusable --expiration 87600h
```

cortado is joined by hand, since the nix-darwin tailscale module has no `authKeyFile` or `extraUpFlags`:

```
sudo tailscale up --login-server=https://headscale.anish.land --auth-key=<key> --ssh --advertise-exit-node
```

## DNS

MagicDNS uses `base_domain = ts.anish.land`, so nodes resolve as `<host>.ts.anish.land`. Service aliases that aren't nodes are headscale `extra_records` generated from `flake.services.tailnet`.

On macOS, tailscaled writes `/etc/resolver/ts.anish.land` itself.

## Access

The headscale policy allows traffic between all nodes and enables Tailscale SSH for tailnet members. On servers, SSH listens only on the `tailscale0` interface.
