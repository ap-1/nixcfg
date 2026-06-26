{ config, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.nixos.web-proxy =
    {
      config,
      lib,
      ...
    }:
    let
      cfg = config.services.webProxy;
    in
    {
      options.services.webProxy = {
        domain = lib.mkOption {
          type = lib.types.str;
          description = "base domain; each site is served at <name>.<domain>";
        };
        wildcard = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "use one *.<domain> cert instead of a cert per site";
        };
        tailnetOnly = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = "expose 443 only on tailscale0 rather than publicly";
        };
        credentialsFile = lib.mkOption {
          type = lib.types.path;
          description = "cloudflare dns-01 credentials env file";
        };
        sites = lib.mkOption {
          type = lib.types.attrsOf lib.types.lines;
          default = { };
          description = "map of <name> to its caddy site block";
        };
      };

      config = lib.mkIf (cfg.sites != { }) {
        security.acme = {
          acceptTerms = true;
          defaults = {
            email = meta.email;
            dnsProvider = "cloudflare";
            dnsResolver = "1.1.1.1:53";
            environmentFile = cfg.credentialsFile;
          };
          certs =
            if cfg.wildcard then
              { "${cfg.domain}".domain = "*.${cfg.domain}"; }
            else
              lib.mapAttrs' (name: _: lib.nameValuePair "${name}.${cfg.domain}" { }) cfg.sites;
        };

        services.caddy = {
          enable = true;
          virtualHosts = lib.mapAttrs' (
            name: extraConfig:
            lib.nameValuePair "${name}.${cfg.domain}" {
              useACMEHost = if cfg.wildcard then cfg.domain else "${name}.${cfg.domain}";
              inherit extraConfig;
            }
          ) cfg.sites;
        };

        networking.firewall.allowedTCPPorts = lib.mkIf (!cfg.tailnetOnly) [
          80
          443
        ];
        networking.firewall.interfaces.tailscale0.allowedTCPPorts = lib.mkIf cfg.tailnetOnly [ 443 ];
      };
    };
}
