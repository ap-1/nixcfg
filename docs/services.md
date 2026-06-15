# Services

Both exposure surfaces come from the `flake.services` registry:

```nix
flake.services = {
  public.git = "reverse_proxy http://127.0.0.1:3001";  # caddy site block
  tailnet.pdf = "mocha";                               # alias -> host
};
```

Each `services.public` entry becomes an ACME certificate and a Caddy vhost at `<name>.anish.land`. Each `services.tailnet` entry becomes a headscale DNS record at `<name>.ts.anish.land` pointing at that host.

## Public service

A public service comprises:

- an entry in `services.public.<name>` whose value is its Caddy site block, from which the certificate and vhost are generated;
- a matching `<name>` in the OpenTofu Cloudflare `subdomains` list, applied with `tofu apply`;
- a module binding the app to its local port, imported by affogato's role.

A service gated by [kanidm](https://kanidm.com/) OIDC has a client in the kanidm `oauth2` attrset. An entry sets only its display name, subdomain, callback path, and access group; the client, group, secret declaration, and `anish`'s membership are generated from it. The client secret lives in a [secret](secrets.md), and the app authenticates against `https://idp.anish.land/oauth2/openid/<name>`.

A stateful service additionally has its state directory in affogato's [preservation set](architecture.md#persistence).

## Tailnet service

A tailnet service is a module on its host binding the app to a port, with the firewall opened only on `tailscale0`. An optional `services.tailnet.<name> = "<host>"` entry adds an alias at `<name>.ts.anish.land`.
