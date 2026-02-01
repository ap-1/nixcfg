{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.tailscale-serve;
  serviceNames = attrNames cfg;
in
{
  options.services.tailscale-serve = mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          port = mkOption {
            type = types.port;
            description = "Local port to serve";
          };
          https = mkOption {
            type = types.port;
            default = 443;
            description = "HTTPS port to expose on tailnet";
          };
          insecure = mkOption {
            type = types.bool;
            default = false;
            description = "Backend uses HTTPS with self-signed cert";
          };
        };
      }
    );
    default = { };
    description = "Services to expose via tailscale serve";
  };

  config = mkIf (cfg != { }) {
    systemd.services =
      let
        indexed = imap0 (i: name: {
          inherit i name;
          opts = cfg.${name};
        }) serviceNames;
      in
      listToAttrs (
        map (
          {
            i,
            name,
            opts,
          }:
          nameValuePair "tailscale-serve-${name}" {
            description = "Tailscale Serve for ${name}";
            after = [
              "tailscaled.service"
            ]
            ++ optional (i > 0) "tailscale-serve-${elemAt serviceNames (i - 1)}.service";
            wants = [ "tailscaled.service" ];
            wantedBy = [ "multi-user.target" ];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg --https=${toString opts.https} ${
                if opts.insecure then "https+insecure" else "http"
              }://localhost:${toString opts.port}";
              ExecStop = "${pkgs.tailscale}/bin/tailscale serve --https=${toString opts.https} off";
            };
          }
        ) indexed
      );
  };
}
