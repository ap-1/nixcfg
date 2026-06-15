let
  anish = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDwjDM2gTgro+aN81I65BFexfLXq1u/8AJ3PmCTX5X/a i@anish.land";

  cortado = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN58RgxMAtPo7du0WeUKvhSx05rcBHqSHI9M0txrvsV8";
  mocha = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFBu43o7nsVIt9KB1hpc+vCEY1CkROhQ01ZulhwtEs2j root@ap-1";
  affogato = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJuVngSRaPAgi3U7p3QQkItSHEga9Dh4kmzFdeEMhWz root@affogato";

  all = [
    anish
    cortado
    mocha
    affogato
  ];
in
{
  "secrets/vaultwarden.age".publicKeys = all;
  "secrets/stash-jwt.age".publicKeys = all;
  "secrets/stash-session.age".publicKeys = all;
  "secrets/stash-password.age".publicKeys = all;
  "secrets/opentofu.age".publicKeys = [ anish ];
  "secrets/affogato-password.age".publicKeys = [
    anish
    affogato
  ];
  "secrets/affogato-cloudflare-dns.age".publicKeys = [
    anish
    affogato
  ];
  "secrets/kanidm-admin.age".publicKeys = [
    anish
    affogato
  ];
  "secrets/kanidm-idm-admin.age".publicKeys = [
    anish
    affogato
  ];
  "secrets/kanidm-oauth2-headscale.age".publicKeys = [
    anish
    affogato
  ];
  "secrets/kanidm-oauth2-headplane.age".publicKeys = [
    anish
    affogato
  ];
  "secrets/headplane-cookie-secret.age".publicKeys = [
    anish
    affogato
  ];
  "secrets/headscale-api-key.age".publicKeys = [
    anish
    affogato
  ];
  "secrets/kanidm-oauth2-vaultwarden.age".publicKeys = [
    anish
    affogato
  ];
  "secrets/headscale-authkey-mocha.age".publicKeys = [
    anish
    mocha
  ];
  "secrets/headscale-authkey-affogato.age".publicKeys = [
    anish
    affogato
  ];
  "secrets/headscale-authkey-cortado.age".publicKeys = [
    anish
    cortado
  ];
  "secrets/kanidm-oauth2-forgejo.age".publicKeys = [
    anish
    affogato
  ];
}
