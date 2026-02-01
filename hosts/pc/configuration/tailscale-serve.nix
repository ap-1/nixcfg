{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.services.tailscale-serve;
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
        };
      }
    );
    default = { };
    description = "Services to expose via tailscale serve";
  };

  config = mkIf (cfg != { }) {
    systemd.services = mapAttrs' (
      name: opts:
      nameValuePair "tailscale-serve-${name}" {
        description = "Tailscale Serve for ${name}";
        after = [ "tailscaled.service" ];
        wants = [ "tailscaled.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.tailscale}/bin/tailscale serve --bg --https=${toString opts.https} http://localhost:${toString opts.port}";
          ExecStop = "${pkgs.tailscale}/bin/tailscale serve --https=${toString opts.https} off";
        };
      }
    ) cfg;
  };
}
