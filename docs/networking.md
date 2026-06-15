# Networking

The fleet runs on a self-hosted [headscale](https://headscale.net/) control plane on affogato. Hosts connect to `https://headscale.anish.land`.

## Joining a host

NixOS hosts authenticate with a reusable headscale pre-auth key, stored as an [agenix secret](secrets.md) and wired through `services.tailscale.authKeyFile`. The shared tailscale module also sets `extraUpFlags` for the login server, Tailscale SSH, and exit-node advertisement. They take effect only at (re)authentication, so re-joining a host requires a `tailscale logout` and a restart of `tailscaled-autoconnect`.

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

nix-darwin's tailscale module only writes a resolver for Tailscale's own `ts.net` suffix, so the shared darwin module adds `/etc/resolver/ts.anish.land` pointing at `100.100.100.100`.

## Access

The headscale policy allows traffic between all nodes and enables Tailscale SSH for tailnet members. On servers, SSH listens only on the `tailscale0` interface.
