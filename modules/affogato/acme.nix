{
  flake.modules.nixos.affogato-acme =
    { config, ... }:
    {
      age.secrets.affogato-cloudflare-dns.file = ../../secrets/affogato-cloudflare-dns.age;

      security.acme = {
        acceptTerms = true;
        defaults = {
          email = "i@anish.land";
          dnsProvider = "cloudflare";
          dnsResolver = "1.1.1.1:53";
          environmentFile = config.age.secrets.affogato-cloudflare-dns.path;
        };
        certs = {
          "idp.anish.land" = { };
          "headscale.anish.land" = { };
          "headplane.anish.land" = { };
          "vault.anish.land" = { };
          "git.anish.land" = { };
        };
      };
    };
}
