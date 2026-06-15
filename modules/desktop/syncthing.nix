{ config, ... }:
let
  hosts = config.flake.hosts;
in
{
  flake.modules.homeManager.syncthing =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.syncthing ];

      services.syncthing = {
        enable = true;
        extraOptions = [ "--gui-address=127.0.0.1:8384" ];

        settings = {
          gui.insecureSkipHostcheck = true;

          devices = {
            mocha = {
              id = hosts.mocha.syncthingId;
              addresses = [ "tcp://${hosts.mocha.tailnet.ipv4}:22000" ];
            };
            cortado = {
              id = hosts.cortado.syncthingId;
              addresses = [ "tcp://${hosts.cortado.tailnet.ipv4}:22000" ];
            };
          };

          folders = {
            projects = {
              path = "~/Projects";
              devices = [
                "mocha"
                "cortado"
              ];
            };
            omp = {
              path = "~/.omp";
              devices = [
                "mocha"
                "cortado"
              ];
            };
          };

          options = {
            globalAnnounceEnabled = false;
            localAnnounceEnabled = false;
            relaysEnabled = false;
            urAccepted = -1;
          };
        };
      };

      home.file."Projects/.stignore".text = ''
        target/
        node_modules/
        .direnv/
        result
      '';

      home.file.".omp/.stignore".text = ''
        logs/
      '';
    };

  # Firewall for tailnet sync
  flake.modules.nixos.syncthing = {
    networking.firewall.interfaces.tailscale0 = {
      allowedTCPPorts = [ 22000 ];
      allowedUDPPorts = [ 22000 ];
    };
  };
}
