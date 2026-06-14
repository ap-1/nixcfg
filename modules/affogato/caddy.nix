{
  flake.modules.nixos.affogato-caddy = {
    services.caddy = {
      enable = true;
      virtualHosts = {
        "idp.anish.land" = {
          useACMEHost = "idp.anish.land";
          extraConfig = ''
            reverse_proxy https://127.0.0.1:8443 {
              transport http {
                tls_server_name idp.anish.land
              }
            }
          '';
        };
        "headscale.anish.land" = {
          useACMEHost = "headscale.anish.land";
          extraConfig = "reverse_proxy http://127.0.0.1:8080";
        };
        "headplane.anish.land" = {
          useACMEHost = "headplane.anish.land";
          extraConfig = ''
            redir / /admin
            reverse_proxy http://127.0.0.1:3000
          '';
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}
