{ ... }:

{
  imports = [ ./tailscale-serve.nix ];

  services.tailscale-serve.sunshine = {
    port = 8384;
    https = 8384;
  };

  services.syncthing = {
    user = "anish";
    dataDir = "/home/anish";
    openFirewall = true;
    guiAddress = "127.0.0.1:8384";
  };
}
