{ inputs, ... }:
{
  flake.modules.homeManager.discord =
    { pkgs, ... }:
    {
      imports = [ inputs.moonlight.homeModules.default ];

      home.packages = [
        (pkgs.discord-canary.override {
          withMoonlight = true;
          moonlight = inputs.moonlight.packages.${pkgs.stdenv.hostPlatform.system}.moonlight;
        })
      ];

      programs.moonlight = {
        enable = true;
        configs.canary = { };
      };
    };
}
