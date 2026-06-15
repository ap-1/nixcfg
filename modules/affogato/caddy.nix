{ config, ... }:
let
  meta = config.flake.meta;
  public = config.flake.services.public;
in
{
  flake.modules.nixos.affogato-caddy =
    { lib, ... }:
    {
      services.caddy = {
        enable = true;
        virtualHosts = lib.mapAttrs' (
          name: extraConfig:
          lib.nameValuePair "${name}.${meta.domain}" {
            useACMEHost = "${name}.${meta.domain}";
            inherit extraConfig;
          }
        ) public;
      };

      networking.firewall.allowedTCPPorts = [
        80
        443
      ];
    };
}
