{
  flake.modules.nixos.homepage =
    { config, ... }:
    let
      cfg = config.services.tailscale-tls;
      host = "${cfg.hostname}.${cfg.tailnet}";
    in
    {
      age.secrets.homepage-dashboard.file = ../../secrets/homepage-dashboard.age;

      services.tailscale-tls.proxies.homepage = {
        port = 18082;
        https = 443;
      };

      services.homepage-dashboard = {
        enable = true;
        environmentFiles = [ config.age.secrets.homepage-dashboard.path ];
        listenPort = 18082;
        services = [
          {
            "Media" = [
              {
                "Jellyfin" = {
                  href = "https://${host}:8096";
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
                  href = "https://${host}:2283";
                  icon = "immich";
                  widget = {
                    type = "immich";
                    url = "http://localhost:12283";
                    key = "{{HOMEPAGE_VAR_IMMICH_KEY}}";
                    version = 2;
                  };
                };
              }
              {
                "Stash" = {
                  href = "https://${host}:9999";
                  description = "Media organizer";
                };
              }
              {
                "Suwayomi" = {
                  href = "https://${host}:4567";
                  description = "Manga reader";
                };
              }
            ];
          }
          {
            "Downloads" = [
              {
                "qBittorrent" = {
                  href = "https://${host}:8080";
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
                  href = "https://${host}:9091";
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
                  href = "https://${host}:8989";
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
                  href = "https://${host}:7878";
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
                  href = "https://${host}:8686";
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
                  href = "https://${host}:8787";
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
                  href = "https://${host}:9696";
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
                  href = "https://${host}:6767";
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
                  href = "https://${host}:8222";
                  icon = "vaultwarden";
                  description = "Password manager";
                };
              }
              {
                "Sunshine" = {
                  href = "https://${host}:47990";
                  icon = "sunshine";
                  description = "Game streaming";
                };
              }
              {
                "Syncthing" = {
                  href = "https://${host}:8384";
                  icon = "syncthing";
                  description = "File sync";
                };
              }
              {
                "Syncthing (Mac)" = {
                  href = "https://macbook.${cfg.tailnet}:8384";
                  icon = "syncthing";
                  description = "File sync";
                };
              }
            ];
          }
        ];
      };
    };
}
