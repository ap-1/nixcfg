# Services

Both exposure surfaces come from the `flake.services` registry:

```nix
flake.services = {
  public.git = "reverse_proxy http://127.0.0.1:3001";  # caddy site block
  tailnet.pdf = "mocha";                               # alias -> host
};
```

A `services.public` entry maps a name to the Caddy site block that fronts it, and the name becomes a certificate and a virtual host at `<name>.anish.land`. A `services.tailnet` entry maps a name to the host that serves it, and the name becomes a headscale DNS record at `<name>.ts.anish.land` resolving to that host.

## Reverse proxy and certificates

Every host that exposes services imports a shared proxy module that turns a set of named Caddy site blocks into virtual hosts and provisions the ACME certificates they use. Certificates are always issued over the Cloudflare DNS-01 challenge, which proves domain control through DNS records and so requires the Cloudflare API token as a [secret](secrets.md).

affogato sets its domain to `anish.land`, takes its site blocks straight from `services.public`, issues a separate certificate per name, and opens ports 80 and 443 publicly. A tailnet host such as mocha sets its domain to `ts.anish.land`, issues a single `*.ts.anish.land` wildcard certificate, and opens port 443 only on the `tailscale0` interface, so its services are reachable only over the mesh.

## Public service

A public service comprises:

- an entry in `services.public.<name>` whose value is its Caddy site block, from which the certificate and virtual host are generated;
- a matching `<name>` in the OpenTofu Cloudflare `subdomains` list, applied with `tofu apply`, which publishes the `A` and `AAAA` records pointing the name at affogato;
- a module binding the app to its local port, imported by affogato's role.

A stateful service additionally has its state directory in affogato's [preservation set](architecture.md#persistence).

## Tailnet service

A tailnet service is served by its host's own Caddy at `<name>.ts.anish.land` and is reachable only over the mesh. Its module binds the app to a loopback port and registers the Caddy site block that proxies to it, so the wildcard certificate covers it without further configuration. The `services.tailnet.<name> = "<host>"` entry names the host that serves it, which is what generates the matching MagicDNS record.

## OIDC

A service gated by [kanidm](https://kanidm.com/) has a client in the kanidm `oauth2` attrset. An entry sets its display name, subdomain, and access group, together with either a callback path or an explicit list of redirect origins, and a tailnet client also names its domain. The client, its access group, the secret declaration, and `anish`'s membership are generated from the entry. The client secret lives in a [secret](secrets.md), and the app authenticates against `https://idp.anish.land/oauth2/openid/<name>`.
