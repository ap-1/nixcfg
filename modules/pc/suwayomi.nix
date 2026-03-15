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
          flareSolverrEnabled = true;
          flareSolverrUrl = "http://localhost:8191";
        };
      };
    };
}
