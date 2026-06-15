{
  flake.modules.nixos.postgres =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      cfg = config.services.postgresApps;
      managed = lib.filterAttrs (_: a: a.service != null) cfg;
    in
    {
      options.services.postgresApps = lib.mkOption {
        default = { };
        description = "Apps given a database on the shared postgres instance";
        type = lib.types.attrsOf (
          lib.types.submodule (
            { name, ... }:
            {
              options = {
                service = lib.mkOption {
                  type = lib.types.nullOr lib.types.str;
                  default = null;
                  description = "Systemd service to run as the db role";
                };
                url = lib.mkOption {
                  type = lib.types.str;
                  readOnly = true;
                  default = "postgresql://${name}@/${name}?host=/run/postgresql";
                  description = "Socket connection url";
                };
              };
            }
          )
        );
      };

      config = lib.mkIf (cfg != { }) {
        services.postgresql = {
          enable = true;
          package = pkgs.postgresql_18;
          ensureDatabases = lib.attrNames cfg;
          ensureUsers = lib.mapAttrsToList (name: _: {
            inherit name;
            ensureDBOwnership = true;
            ensureClauses.login = true;
          }) cfg;
        };

        services.postgresqlBackup.enable = true;

        users.users = lib.mapAttrs (name: _: {
          isSystemUser = true;
          group = name;
        }) managed;
        users.groups = lib.mapAttrs (_: _: { }) managed;

        systemd.services = lib.mapAttrs' (
          name: a:
          lib.nameValuePair a.service {
            after = [ "postgresql.target" ];
            requires = [ "postgresql.target" ];
            serviceConfig = {
              DynamicUser = lib.mkForce false;
              User = name;
              Group = name;
            };
          }
        ) managed;
      };
    };
}
