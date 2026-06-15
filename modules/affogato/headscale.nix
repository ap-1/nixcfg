{ config, lib, ... }:
let
  meta = config.flake.meta;
  hosts = config.flake.hosts;
  tailnetAliases = config.flake.services.tailnet;
in
{
  flake.modules.nixos.affogato-headscale =
    { config, ... }:
    {
      age.secrets.headscale-oidc = {
        file = ../../secrets/kanidm-oauth2-headscale.age;
        owner = "headscale";
        group = "headscale";
        mode = "0440";
      };

      services.headscale = {
        enable = true;
        address = "127.0.0.1";
        port = 8080;
        settings = {
          server_url = "https://headscale.${meta.domain}";

          dns = {
            magic_dns = true;
            base_domain = meta.tailnetDomain;
            override_local_dns = false;
            extra_records = lib.concatLists (
              lib.mapAttrsToList (
                name: hostName:
                let
                  host = hosts.${hostName};
                in
                [
                  {
                    name = "${name}.${meta.tailnetDomain}";
                    type = "A";
                    value = host.tailnet.ipv4;
                  }
                  {
                    name = "${name}.${meta.tailnetDomain}";
                    type = "AAAA";
                    value = host.tailnet.ipv6;
                  }
                ]
              ) tailnetAliases
            );
          };

          oidc = {
            issuer = "${meta.idpUrl}/oauth2/openid/headscale";
            client_id = "headscale";
            client_secret_path = config.age.secrets.headscale-oidc.path;
            scope = [
              "openid"
              "profile"
              "email"
              "groups"
            ];
            pkce.enabled = true;
            allowed_groups = [ "headscale.access@${meta.idpDomain}" ];
            only_start_if_oidc_is_available = true;
          };

          policy = {
            mode = "file";
            path = builtins.toFile "headscale-acl.json" (builtins.toJSON {
              acls = [
                {
                  action = "accept";
                  src = [ "*" ];
                  dst = [ "*:*" ];
                }
              ];
              ssh = [
                {
                  action = "accept";
                  src = [ "autogroup:member" ];
                  dst = [ "autogroup:self" ];
                  users = [ "autogroup:nonroot" ];
                }
              ];
            });
          };
        };
      };

      systemd.services.headscale = {
        wants = [ "kanidm.service" ];
        after = [ "kanidm.service" ];
        partOf = [ "kanidm.service" ];
      };
    };
}
