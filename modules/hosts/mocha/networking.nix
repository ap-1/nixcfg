{ config, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.nixos.mocha-networking = { config, pkgs, ... }: {
    networking.hostName = "mocha";

    # TODO: not in linux-firmware yet (https://gitlab.com/kernel-firmware/linux-firmware/-/merge_requests/946)
    hardware.firmware = [
      (pkgs.runCommandLocal "mt7927-bt-firmware" { } ''
        install -Dm644 ${./BT_RAM_CODE_MT6639_2_1_hdr.bin} \
          "$out/lib/firmware/mediatek/mt7927/BT_RAM_CODE_MT6639_2_1_hdr.bin"
      '')
    ];

    age.secrets.cloudflare-dns.file = ../../../secrets/cloudflare-dns.age;

    services.webProxy = {
      domain = meta.tailnetDomain;
      wildcard = true;
      tailnetOnly = true;
      credentialsFile = config.age.secrets.cloudflare-dns.path;
    };
  };
}
