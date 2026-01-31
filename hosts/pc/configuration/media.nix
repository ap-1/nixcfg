{ pkgs, ... }:

{
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  services.sonarr = {
    enable = true;
    openFirewall = true;
  };

  services.radarr = {
    enable = true;
    openFirewall = true;
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.bazarr = {
    enable = true;
    openFirewall = true;
  };

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    openFirewall = true;
    settings = {
      download-dir = "/media/downloads";
      incomplete-dir = "/media/downloads/.incomplete";
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist-enabled = false;
    };
  };

  # Shared media group
  users.groups.media = {};

  users.users.anish.extraGroups = [ "media" ];
  users.users.jellyfin.extraGroups = [ "media" ];
  users.users.sonarr.extraGroups = [ "media" ];
  users.users.radarr.extraGroups = [ "media" ];
  users.users.transmission.extraGroups = [ "media" ];

  # Directories
  systemd.tmpfiles.rules = [
    "d /media 0775 root media -"
    "d /media/downloads 0775 root media -"
    "d /media/downloads/.incomplete 0775 root media -"
    "d /media/movies 0775 root media -"
    "d /media/tv 0775 root media -"
  ];
}
