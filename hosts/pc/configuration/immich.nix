{ config, pkgs, ... }:

{
  imports = [ ../../../tailscale-serve.nix ];

  services.tailscale-serve.immich = {
    port = 2283;
    https = 2283;
  };

  services.immich = {
    enable = true;
    host = "127.0.0.1";
    port = 2283;
    mediaLocation = "/media/immich";
    machine-learning.enable = true;

    # Hardware Accelerated Video Transcoding
    accelerationDevices = null;
  };

  users.users.immich.extraGroups = [
    "video"
    "render"
  ];

  # Directories
  systemd.tmpfiles.rules = [
    "d /media/immich 0750 immich immich -"
  ];
}
