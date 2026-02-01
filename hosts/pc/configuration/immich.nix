{ config, pkgs, ... }:

{
  services.immich = {
    enable = true;
    host = "0.0.0.0";
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
