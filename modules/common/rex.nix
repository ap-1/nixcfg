{ inputs, ... }:
{
  flake.modules.nixos.rex = {
    imports = [ inputs.rex.nixosModules.default ];

    services.rex = {
      enable = true;
      user = "anish";
      group = "users";
      socketMode = "0600";
      extraListen = [ "tailnet://:7297" ];
    };

    environment.sessionVariables.REX_RUNTIME_DIR = "/run/rex";

    networking.firewall.interfaces.tailscale0.allowedTCPPorts = [ 7297 ];
  };
}
