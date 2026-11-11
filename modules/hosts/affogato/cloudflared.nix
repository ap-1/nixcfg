{ config, ... }:
let
  meta = config.flake.meta;
  tunnel = config.flake.services.tunnel;
  tunnelId = config.flake.hosts.affogato.cloudflareTunnel;
in
{
  flake.modules.nixos.affogato-cloudflared =
    {
      config,
      lib,
      ...
    }:
    {
      age.secrets.cloudflared-tunnel.file = ../../../secrets/cloudflared-tunnel.age;

      services.cloudflared = {
        enable = true;
        tunnels.${tunnelId} = {
          credentialsFile = config.age.secrets.cloudflared-tunnel.path;
          default = "http_status:404";
          ingress = (lib.mapAttrs' (name: url: lib.nameValuePair "${name}.${meta.domain}" url) tunnel) // {
            # kanidm serves HTTPS with a self-signed cert, skip origin TLS verification
            # https://github.com/kanidm/kanidm/discussions/3455
            "idp.${meta.domain}" = {
              service = tunnel.idp;
              originRequest.noTLSVerify = true;
            };
          };
        };
      };

      # only allow post-quantum connections to cloudflare
      systemd.services."cloudflared-tunnel-${tunnelId}".environment.TUNNEL_POST_QUANTUM = "true";
    };
}
