{
  flake.modules.nixos.dns = {
    services.resolved.settings.Resolve = {
      DNS = [
        "1.1.1.1#cloudflare-dns.com"
        "1.0.0.1#cloudflare-dns.com"
        "2606:4700:4700::1111#cloudflare-dns.com"
        "2606:4700:4700::1001#cloudflare-dns.com"
      ];
      DNSOverTLS = true;
      # route all lookups here instead of dhcp-provided servers
      Domains = [ "~." ];
    };
  };

  flake.modules.darwin.dns = { lib, ... }: {
    services.dnscrypt-proxy = {
      enable = true;
      settings = {
        listen_addresses = [
          "127.0.0.1:53"
          "[::1]:53"
        ];
        # binding port 53 needs root; drop to the service user afterwards
        user_name = "_dnscrypt-proxy";
        # https://<ip>/dns-query
        static = {
          cloudflare-1111.stamp = "sdns://AgcAAAAAAAAAAAAHMS4xLjEuMQovZG5zLXF1ZXJ5";
          cloudflare-1001.stamp = "sdns://AgcAAAAAAAAAAAAHMS4wLjAuMQovZG5zLXF1ZXJ5";
          cloudflare-ipv6-1111.stamp = "sdns://AgcAAAAAAAAAAAAWWzI2MDY6NDcwMDo0NzAwOjoxMTExXQovZG5zLXF1ZXJ5";
          cloudflare-ipv6-1001.stamp = "sdns://AgcAAAAAAAAAAAAWWzI2MDY6NDcwMDo0NzAwOjoxMDAxXQovZG5zLXF1ZXJ5";
        };
      };
    };

    # TODO: https://github.com/nix-darwin/nix-darwin/issues/1408
    launchd.daemons.dnscrypt-proxy.serviceConfig = {
      UserName = lib.mkForce null;
      GroupName = lib.mkForce null;
    };

    networking.dns = [
      "127.0.0.1"
      "::1"
    ];
  };
}
