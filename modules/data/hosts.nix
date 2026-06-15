{
  flake.hosts = {
    cortado = {
      sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN58RgxMAtPo7du0WeUKvhSx05rcBHqSHI9M0txrvsV8";
      syncthingId = "4SSWKFI-YYBZSNO-2AWRLQR-FIWUTGQ-IQ3PJ6S-ZYCXHV5-BHL5MNJ-XZAOMQ6";
      tailnet = {
        ipv4 = "100.64.0.1";
        ipv6 = "fd7a:115c:a1e0::1";
      };
    };
    mocha = {
      sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFBu43o7nsVIt9KB1hpc+vCEY1CkROhQ01ZulhwtEs2j root@ap-1";
      syncthingId = "7VKJ6MX-CPUQ75F-XGQB6GL-QWY2ER3-2U4XB4I-YHDOCZH-ZI4VCIN-ZXSHHAN";
      tailnet = {
        ipv4 = "100.64.0.2";
        ipv6 = "fd7a:115c:a1e0::2";
      };
    };
    affogato = {
      sshKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKJuVngSRaPAgi3U7p3QQkItSHEga9Dh4kmzFdeEMhWz root@affogato";
      tailnet = {
        ipv4 = "100.64.0.3";
        ipv6 = "fd7a:115c:a1e0::3";
      };
      publicIpv4 = "167.233.47.157";
      publicIpv6 = "2a01:4f8:1c18:fd::1";
    };
  };
}
