{ config, ... }:
let
  meta = config.flake.meta;
  public = config.flake.services.public;
in
{
  flake.modules.nixos.affogato-acme =
    { config, lib, ... }:
    {
      age.secrets.affogato-cloudflare-dns.file = ../../secrets/affogato-cloudflare-dns.age;

      security.acme = {
        acceptTerms = true;
        defaults = {
          email = meta.email;
          dnsProvider = "cloudflare";
          dnsResolver = "1.1.1.1:53";
          environmentFile = config.age.secrets.affogato-cloudflare-dns.path;
        };
        certs = lib.mapAttrs' (name: _: lib.nameValuePair "${name}.${meta.domain}" { }) public;
      };
    };
}
