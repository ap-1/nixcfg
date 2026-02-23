{ ... }:
{
  flake.modules.homeManager.discord =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.discord-canary ];

      # TODO: add moonlight
    };
}
