{
  flake.modules.nixos.suwayomi =
    { ... }:
    {
      services.suwayomi-server = {
        enable = true;
        openFirewall = true;
        settings.server = {
          ip = "127.0.0.1";
          port = 4567;
          flareSolverrEnabled = true;
          flareSolverrUrl = "http://localhost:8191";
        };
      };
    };
}
