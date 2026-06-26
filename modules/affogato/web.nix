{ config, ... }:
let
  meta = config.flake.meta;
  public = config.flake.services.public;
in
{
  flake.modules.nixos.affogato-web = { config, ... }: {
    age.secrets.cloudflare-dns.file = ../../secrets/cloudflare-dns.age;

    services.webProxy = {
      domain = meta.domain;
      credentialsFile = config.age.secrets.cloudflare-dns.path;
      sites = public;
    };
  };
}
