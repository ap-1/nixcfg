{
  flake.services = {
    # affogato caddy + acme cert at <name>.<domain>; value is the caddy site block
    public = {
      idp = ''
        reverse_proxy https://127.0.0.1:8443 {
          transport http {
            tls_server_name idp.anish.land
          }
        }
      '';
      headscale = "reverse_proxy http://127.0.0.1:8080";
      headplane = ''
        redir / /admin
        reverse_proxy http://127.0.0.1:3000
      '';
      vault = "reverse_proxy http://127.0.0.1:8222";
      git = "reverse_proxy http://127.0.0.1:3001";
    };

    # headscale dns alias <name>.<tailnetDomain> -> the named host
    tailnet = {
      pdf = "mocha";
      chat = "mocha";
    };
  };
}
