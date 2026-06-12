{
  flake.modules.nixos.suwayomi =
    { ... }:
    {
      services.tailscale-tls.proxies.suwayomi = {
        port = 14567;
        https = 4567;
      };

      services.suwayomi-server = {
        enable = true;
        settings.server = {
          ip = "127.0.0.1";
          port = 14567;
          autoDownloadNewChapters = true;
          excludeEntryWithUnreadChapters = true;
          flareSolverrEnabled = true;
          flareSolverrUrl = "http://localhost:8191";
          extensionRepos = [
            "https://raw.githubusercontent.com/suwayomi/tachiyomi-extension/repo/index.min.json"
            "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
          ];
        };
      };
    };
}
