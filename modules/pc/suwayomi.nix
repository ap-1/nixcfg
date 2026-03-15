{
  flake.modules.nixos.suwayomi =
    { ... }:
    {
      services.suwayomi-server = {
        enable = true;
        openFirewall = true;
        settings.server = {
          ip = "0.0.0.0";
          port = 4567;
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
