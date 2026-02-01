{ ... }:

{
  imports = [ ./tailscale-serve.nix ];

  services.tailscale-serve.syncthing = {
    port = 8384;
    https = 8384;
  };

  services.syncthing = {
    enable = true;
    user = "anish";
    dataDir = "/home/anish";
    guiAddress = "127.0.0.1:8384";
    openDefaultPorts = true;
    settings.gui.insecureSkipHostcheck = true;
  };
}
