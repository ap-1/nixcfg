{ config, ... }:
let
  meta = config.flake.meta;
  tunnel = config.flake.services.tunnel;

  # created with: cloudflared tunnel create affogato
  # credential json stored as agenix secret
  tunnelId = "57460d10-8d73-4518-846e-099860cb6200";
in
{
  flake.modules.nixos.affogato-cloudflared =
    {
      config,
      lib,
      ...
    }:
    {
      age.secrets.cloudflared-tunnel.file = ../../secrets/cloudflared-tunnel.age;

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
    };
}
