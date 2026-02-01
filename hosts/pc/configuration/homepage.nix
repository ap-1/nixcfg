{ config, ... }:

{
  imports = [ ./tailscale-serve.nix ];

  services.tailscale-serve.homepage = {
    port = 8082;
    https = 443;
  };

  age.secrets.homepage-dashboard.file = ../../../secrets/homepage-dashboard.age;

  services.homepage-dashboard = {
    enable = true;
    openFirewall = true;
    environmentFile = config.age.secrets.homepage-dashboard.path;
    services = [
      {
        "Media" = [
          {
            "Jellyfin" = {
              href = "https://pc.meteor-banjo.ts.net:8096";
              icon = "jellyfin";
              widget = {
                type = "jellyfin";
                url = "http://localhost:8096";
                key = "{{HOMEPAGE_VAR_JELLYFIN_KEY}}";
              };
            };
          }
          {
            "Immich" = {
              href = "https://pc.meteor-banjo.ts.net:2283";
              icon = "immich";
              widget = {
                type = "immich";
                url = "http://localhost:2283";
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
              href = "https://pc.meteor-banjo.ts.net:8080";
              icon = "qbittorrent";
              widget = {
                type = "qbittorrent";
                url = "http://localhost:8080";
                username = "anish";
                password = "{{HOMEPAGE_VAR_QBITTORRENT_PASSWORD}}";
              };
            };
          }
          {
            "Transmission" = {
              href = "https://pc.meteor-banjo.ts.net:9091";
              icon = "transmission";
              widget = {
                type = "transmission";
                url = "http://localhost:9091";
                username = "anish";
                password = "{{HOMEPAGE_VAR_TRANSMISSION_PASSWORD}}";
              };
            };
          }
        ];
      }
      {
        "Management" = [
          {
            "Sonarr" = {
              href = "https://pc.meteor-banjo.ts.net:8989";
              icon = "sonarr";
              widget = {
                type = "sonarr";
                url = "http://localhost:8989";
                key = "{{HOMEPAGE_VAR_SONARR_KEY}}";
              };
            };
          }
          {
            "Radarr" = {
              href = "https://pc.meteor-banjo.ts.net:7878";
              icon = "radarr";
              widget = {
                type = "radarr";
                url = "http://localhost:7878";
                key = "{{HOMEPAGE_VAR_RADARR_KEY}}";
              };
            };
          }
          {
            "Lidarr" = {
              href = "https://pc.meteor-banjo.ts.net:8686";
              icon = "lidarr";
              widget = {
                type = "lidarr";
                url = "http://localhost:8686";
                key = "{{HOMEPAGE_VAR_LIDARR_KEY}}";
              };
            };
          }
          {
            "Readarr" = {
              href = "https://pc.meteor-banjo.ts.net:8787";
              icon = "readarr";
              widget = {
                type = "readarr";
                url = "http://localhost:8787";
                key = "{{HOMEPAGE_VAR_READARR_KEY}}";
              };
            };
          }
          {
            "Prowlarr" = {
              href = "https://pc.meteor-banjo.ts.net:9696";
              icon = "prowlarr";
              widget = {
                type = "prowlarr";
                url = "http://localhost:9696";
                key = "{{HOMEPAGE_VAR_PROWLARR_KEY}}";
              };
            };
          }
          {
            "Bazarr" = {
              href = "https://pc.meteor-banjo.ts.net:6767";
              icon = "bazarr";
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
              href = "https://pc.meteor-banjo.ts.net:8222";
              icon = "vaultwarden";
              description = "Password manager";
            };
          }
          {
            "Sunshine" = {
              href = "https://pc.meteor-banjo.ts.net:47990";
              icon = "sunshine";
              description = "Game streaming";
            };
          }
          {
            "Syncthing" = {
              href = "https://pc.meteor-banjo.ts.net:8384";
              icon = "syncthing";
              description = "File sync";
            };
          }
          {
            "Syncthing (Mac)" = {
              href = "https://macbook.meteor-banjo.ts.net:8384";
              icon = "syncthing";
              description = "File sync";
            };
          }
        ];
      }
    ];
  };
}
