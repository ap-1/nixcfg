{
  flake.modules.nixos.suwayomi = { ... }: {
    services.webProxy.sites.suwayomi = "reverse_proxy http://127.0.0.1:14567";

    services.flaresolverr = {
      enable = true;
      openFirewall = true;
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
        flareSolverrAsResponseFallback = true;
        extensionRepos = [
          "https://raw.githubusercontent.com/suwayomi/tachiyomi-extension/repo/index.min.json"
          "https://raw.githubusercontent.com/keiyoushi/extensions/repo/index.min.json"
          "https://raw.githubusercontent.com/yuzono/cursed-manga-repo/repo/index.min.json"
        ];
      };
    };
  };
}
