{ config, pkgs, ... }:

{
  imports = [ ../../../tailscale-serve.nix ];

  services.tailscale-serve = {
    jellyfin = {
      port = 8096;
      https = 8096;
    };
    sonarr = {
      port = 8989;
      https = 8989;
    };
    radarr = {
      port = 7878;
      https = 7878;
    };
    lidarr = {
      port = 8686;
      https = 8686;
    };
    readarr = {
      port = 8787;
      https = 8787;
    };
    prowlarr = {
      port = 9696;
      https = 9696;
    };
    bazarr = {
      port = 6767;
      https = 6767;
    };
    qbittorrent = {
      port = 8080;
      https = 8080;
    };
    transmission = {
      port = 9091;
      https = 9091;
    };
  };

  age.secrets.transmission.file = ../../../secrets/transmission.age;

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
      rpc-whitelist-enabled = false;
      rpc-host-whitelist = "localhost,pc,pc.meteor-banjo.ts.net,macbook,iphone,ipad";
      rpc-host-whitelist-enabled = true;
      rpc-authentication-required = true;
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
    "d /media 2775 root media -"
    "d /media/downloads 2775 root media -"
    "d /media/downloads/.incomplete 2775 root media -"
    "d /media/movies 2775 root media -"
    "d /media/tv 2775 root media -"
    "d /media/music 2775 root media -"
    "d /media/books 2775 root media -"
  ];
}
