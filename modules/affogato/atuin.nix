{
  flake.modules.nixos.affogato-atuin =
    { pkgs, ... }:
    {
      services.atuin = {
        enable = true;
        host = "0.0.0.0";
        port = 8888;
        openRegistration = false;
        database.createLocally = true;
      };

      services.postgresql.package = pkgs.postgresql_18;

      networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 8888 ];
    };
}
