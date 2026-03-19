{
  flake.modules.nixos.tailscale-tls =
    { config, lib, ... }:
    let
      cfg = config.services.tailscale-tls;
      hostname = "${cfg.hostname}.${cfg.tailnet}";
    in
    {
      options.services.tailscale-tls = {
        hostname = lib.mkOption {
          type = lib.types.str;
          example = "pc";
          description = "Tailscale machine name";
        };
        tailnet = lib.mkOption {
          type = lib.types.str;
          example = "meteor-banjo.ts.net";
          description = "Tailnet domain suffix";
        };
        proxies = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                port = lib.mkOption {
                  type = lib.types.port;
                  description = "Local port the backend service listens on";
                };
                https = lib.mkOption {
                  type = lib.types.port;
                  description = "HTTPS port to expose on the tailnet";
                };
              };
            }
          );
          default = { };
          description = "Services to expose via Caddy with Tailscale TLS";
        };
      };

      config = lib.mkIf (cfg.proxies != { }) {
        services.tailscale.permitCertUid = "caddy";

        services.caddy = {
          enable = true;
          virtualHosts = lib.mapAttrs' (
            _: proxy:
            lib.nameValuePair "${hostname}:${toString proxy.https}" {
              extraConfig = ''
                reverse_proxy http://localhost:${toString proxy.port}
              '';
            }
          ) cfg.proxies;
        };

        networking.firewall.allowedTCPPorts = lib.mapAttrsToList (_: proxy: proxy.https) cfg.proxies;
      };
    };
}
