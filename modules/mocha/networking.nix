{ config, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.nixos.mocha-networking = { config, ... }: {
    networking.hostName = "mocha";
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.backend = "iwd";
    networking.wireless.iwd.enable = true;

    hardware.mediatek-mt7927.enable = true;

    age.secrets.headscale-authkey-mocha = {
      file = ../../secrets/headscale-authkey-mocha.age;
      owner = "root";
      group = "root";
      mode = "0400";
    };

    services.tailscale.authKeyFile = config.age.secrets.headscale-authkey-mocha.path;

    age.secrets.cloudflare-dns.file = ../../secrets/cloudflare-dns.age;

    services.webProxy = {
      domain = meta.tailnetDomain;
      wildcard = true;
      tailnetOnly = true;
      credentialsFile = config.age.secrets.cloudflare-dns.path;
    };
  };
}
