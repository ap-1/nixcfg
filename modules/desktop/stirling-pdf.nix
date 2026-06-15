{
  flake.modules.nixos.stirling-pdf = {
    services.stirling-pdf = {
      enable = true;
      environment.SERVER_PORT = 8080;
    };

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 8080 ];
  };
}
