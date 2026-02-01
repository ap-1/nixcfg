{ config, pkgs, ... }:

{
  age.secrets.transmission = {
    file = ../../../secrets/transmission.age;
  };

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

  services.lidarr = {
    enable = true;
    openFirewall = true;
  };

  services.readarr = {
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

  services.flaresolverr = {
    enable = true;
    openFirewall = true;
  };

  services.qbittorrent = {
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
      rpc-host-whitelist-enabled = false;
    };
    credentialsFile = config.age.secrets.transmission.path;
  };

  # Shared media group
  users.groups.media = { };

  users.users.anish.extraGroups = [ "media" ];
  users.users.jellyfin.extraGroups = [ "media" ];
  users.users.sonarr.extraGroups = [ "media" ];
  users.users.radarr.extraGroups = [ "media" ];
  users.users.lidarr.extraGroups = [ "media" ];
  users.users.readarr.extraGroups = [ "media" ];
  users.users.bazarr.extraGroups = [ "media" ];
  users.users.qbittorrent.extraGroups = [ "media" ];
  users.users.transmission.extraGroups = [ "media" ];

  # Directories
  systemd.tmpfiles.rules = [
    "d /media 0775 root media -"
    "d /media/downloads 0775 root media -"
    "d /media/downloads/.incomplete 0775 root media -"
    "d /media/movies 0775 root media -"
    "d /media/tv 0775 root media -"
    "d /media/music 0775 root media -"
    "d /media/books 0775 root media -"
  ];
}
