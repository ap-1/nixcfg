{ ... }:

{
  age.secrets."homepage-dashboard" = {
    file = ../../../secrets/homepage-dashboard.age;
    owner = "homepage-dashboard";
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
              href = "http://localhost:8096";
              widget = {
                type = "jellyfin";
                url = "http://localhost:8096";
                key = "{{HOMEPAGE_VAR_JELLYFIN_KEY}}";
              };
            };
          }
          {
            "Immich" = {
              href = "http://localhost:2283";
              widget = {
                type = "immich";
                url = "http://localhost:2283";
                key = "{{HOMEPAGE_VAR_IMMICH_KEY}}";
              };
            };
          }
        ];
      }
      {
        "Downloads" = [
          {
            "qBittorrent" = {
              href = "http://localhost:8080";
              widget = {
                type = "qbittorrent";
                url = "http://localhost:8080";
              };
            };
          }
          {
            "Transmission" = {
              href = "http://localhost:9091";
              widget = {
                type = "transmission";
                url = "http://localhost:9091";
              };
            };
          }
        ];
      }
      {
        "Management" = [
          {
            "Sonarr" = {
              href = "http://localhost:8989";
              widget = {
                type = "sonarr";
                url = "http://localhost:8989";
                key = "{{HOMEPAGE_VAR_SONARR_KEY}}";
              };
            };
          }
          {
            "Radarr" = {
              href = "http://localhost:7878";
              widget = {
                type = "radarr";
                url = "http://localhost:7878";
                key = "{{HOMEPAGE_VAR_RADARR_KEY}}";
              };
            };
          }
          {
            "Lidarr" = {
              href = "http://localhost:8686";
              widget = {
                type = "lidarr";
                url = "http://localhost:8686";
                key = "{{HOMEPAGE_VAR_LIDARR_KEY}}";
              };
            };
          }
          {
            "Readarr" = {
              href = "http://localhost:8787";
              widget = {
                type = "readarr";
                url = "http://localhost:8787";
                key = "{{HOMEPAGE_VAR_READARR_KEY}}";
              };
            };
          }
          {
            "Prowlarr" = {
              href = "http://localhost:9696";
              widget = {
                type = "prowlarr";
                url = "http://localhost:9696";
                key = "{{HOMEPAGE_VAR_PROWLARR_KEY}}";
              };
            };
          }
          {
            "Bazarr" = {
              href = "http://localhost:6767";
              widget = {
                type = "bazarr";
                url = "http://localhost:6767";
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
              href = "http://localhost:8222";
              icon = "vaultwarden";
              description = "Password manager";
            };
          }
          {
            "Sunshine" = {
              href = "https://localhost:47990";
              icon = "sunshine";
              description = "Game streaming";
            };
          }
        ];
      }
    ];
  };
}
