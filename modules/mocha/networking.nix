{ config, inputs, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.nixos.mocha-networking = { config, pkgs, ... }: {
    networking.hostName = "mocha";
    networking.networkmanager.enable = true;
    networking.networkmanager.wifi.backend = "iwd";
    networking.wireless.iwd.enable = true;

    hardware.mediatek-mt7927.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    # TODO: https://github.com/cmspam/mt7927-nixos/pull/3/
    hardware.firmware = [
      (pkgs.runCommandLocal "mt7927-bt-firmware-path" { } ''
        src=${inputs.mt7927.packages.${pkgs.stdenv.hostPlatform.system}.default}
        install -Dm644 \
          "$src/lib/firmware/mediatek/mt6639/BT_RAM_CODE_MT6639_2_1_hdr.bin" \
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

    programs.mosh.enable = true;
    programs.mosh.openFirewall = false;
    networking.firewall.interfaces.tailscale0.allowedUDPPortRanges = [
      {
        from = 60000;
        to = 61000;
      }
    ];

    age.secrets.cloudflare-dns.file = ../../secrets/cloudflare-dns.age;

    services.webProxy = {
      domain = meta.tailnetDomain;
      wildcard = true;
      tailnetOnly = true;
      credentialsFile = config.age.secrets.cloudflare-dns.path;
    };
  };
}
