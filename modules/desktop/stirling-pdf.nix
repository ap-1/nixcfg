{
  flake.modules.nixos.stirling-pdf = {
    services.stirling-pdf = {
      enable = true;
      environment.SERVER_PORT = 8080;
    };

    services.webProxy.sites.pdf = "reverse_proxy http://127.0.0.1:8080";
  };
}
