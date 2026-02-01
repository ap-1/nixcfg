{ config, ... }:

{
  age.secrets."homepage-dashboard" = {
    file = ../../../secrets/homepage-dashboard.age;
  };

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    environmentFile = config.age.secrets.homepage-dashboard.path;
    services = [
      {
        "Media" = [
          {
            "Jellyfin" = {
              href = "http://pc:8096";
              widget = {
                type = "jellyfin";
                url = "http://pc:8096";
                key = "{{HOMEPAGE_VAR_JELLYFIN_KEY}}";
              };
            };
          }
          {
            "Immich" = {
              href = "http://pc:2283";
              widget = {
                type = "immich";
                url = "http://pc:2283";
                key = "{{HOMEPAGE_VAR_IMMICH_KEY}}";
                version = 2;
              };
            };
          }
        ];
      }
      {
        "Downloads" = [
          {
            "qBittorrent" = {
              href = "http://pc:8080";
              widget = {
                type = "qbittorrent";
                url = "http://pc:8080";
              };
            };
          }
          {
            "Transmission" = {
              href = "http://pc:9091";
              widget = {
                type = "transmission";
                url = "http://pc:9091";
              };
            };
          }
        ];
      }
      {
        "Management" = [
          {
            "Sonarr" = {
              href = "http://pc:8989";
              widget = {
                type = "sonarr";
                url = "http://pc:8989";
                key = "{{HOMEPAGE_VAR_SONARR_KEY}}";
              };
            };
          }
          {
            "Radarr" = {
              href = "http://pc:7878";
              widget = {
                type = "radarr";
                url = "http://pc:7878";
                key = "{{HOMEPAGE_VAR_RADARR_KEY}}";
              };
            };
          }
          {
            "Lidarr" = {
              href = "http://pc:8686";
              widget = {
                type = "lidarr";
                url = "http://pc:8686";
                key = "{{HOMEPAGE_VAR_LIDARR_KEY}}";
              };
            };
          }
          {
            "Readarr" = {
              href = "http://pc:8787";
              widget = {
                type = "readarr";
                url = "http://pc:8787";
                key = "{{HOMEPAGE_VAR_READARR_KEY}}";
              };
            };
          }
          {
            "Prowlarr" = {
              href = "http://pc:9696";
              widget = {
                type = "prowlarr";
                url = "http://pc:9696";
                key = "{{HOMEPAGE_VAR_PROWLARR_KEY}}";
              };
            };
          }
          {
            "Bazarr" = {
              href = "http://pc:6767";
              widget = {
                type = "bazarr";
                url = "http://pc:6767";
                key = "{{HOMEPAGE_VAR_BAZARR_KEY}}";
              };
            };
          }
        ];
      }
      {
        "Tools" = [
          {
            "Vaultwarden" = {
              href = "http://pc:8222";
              icon = "vaultwarden";
              description = "Password manager";
            };
          }
          {
            "Sunshine" = {
              href = "https://pc:47990";
              icon = "sunshine";
              description = "Game streaming";
            };
          }
        ];
      }
    ];
  };
}
