{ config, lib, ... }:
let
  meta = config.flake.meta;
  services = config.flake.services;
  affogato = config.flake.hosts.affogato;

  accountId = "1aeefdcd08c221dbe83c20913cc21c50";
  zoneId = "b2fed9e9f7207a1067f88360e4011ed9";

  # <name>.anish.land record for each service
  records =
    names: attrs:
    {
      for_each = lib.genAttrs names lib.id;
      zone_id = zoneId;
      name = "\${each.key}.${meta.domain}";
    }
    // attrs;

  public = lib.attrNames services.public;
  tunnel = lib.attrNames services.tunnel;
in
{
  perSystem =
    { pkgs, ... }:
    {
      terranix.terranixConfigurations.cloudflare = {
        workdir = ".terranix/cloudflare";

        terraformWrapper = {
          package = pkgs.opentofu;
          extraRuntimeInputs = [ pkgs.rage ];
          prefixText = ''
            creds=$(rage -d -i ~/.ssh/id_ed25519 ${../../secrets/opentofu.age})
            set -a
            eval "$creds"
            set +a
            export AWS_SHARED_CREDENTIALS_FILE=/dev/null
            export AWS_CONFIG_FILE=/dev/null
            export AWS_EC2_METADATA_DISABLED=true
          '';
        };

        modules = [
          {
            terraform = {
              required_version = ">= 1.10";
              required_providers.cloudflare = {
                source = "cloudflare/cloudflare";
                version = "~> 5.0";
              };

              backend.s3 = {
                bucket = "nixcfg-tfstate";
                key = "anish-land/terraform.tfstate";
                region = "auto";
                endpoints.s3 = "https://${accountId}.r2.cloudflarestorage.com";

                # r2 backend compat
                skip_credentials_validation = true;
                skip_metadata_api_check = true;
                skip_region_validation = true;
                skip_requesting_account_id = true;
                use_path_style = true;
              };
            };

            variable.cloudflare_api_token = {
              description = "Cloudflare API token";
              type = "string";
              sensitive = true;
            };

            provider.cloudflare.api_token = "\${var.cloudflare_api_token}";

            resource.cloudflare_dns_record = {
              affogato_a = records public {
                type = "A";
                content = affogato.publicIpv4;
                ttl = 300;
                proxied = false;
              };

              affogato_aaaa = records public {
                type = "AAAA";
                content = affogato.publicIpv6;
                ttl = 300;
                proxied = false;
              };

              tunnel_cname = records tunnel {
                type = "CNAME";
                content = "${affogato.cloudflareTunnel}.cfargotunnel.com";
                ttl = 1;
                proxied = true;
              };
            };
          }
        ];
      };
    };
}
