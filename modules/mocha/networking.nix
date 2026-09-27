{ config, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.nixos.mocha-networking = { config, pkgs, ... }: {
    networking.hostName = "mocha";
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.backend = "iwd";
    networking.wireless.iwd.enable = true;

    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # TODO: not in linux-firmware yet (https://gitlab.com/kernel-firmware/linux-firmware/-/merge_requests/946)
    hardware.firmware = [
      (pkgs.runCommandLocal "mt7927-bt-firmware" { } ''
        install -Dm644 ${./BT_RAM_CODE_MT6639_2_1_hdr.bin} \
          "$out/lib/firmware/mediatek/mt7927/BT_RAM_CODE_MT6639_2_1_hdr.bin"
      '')
    ];

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
