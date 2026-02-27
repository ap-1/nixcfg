{ config, ... }:
{
  flake.modules.homeManager.macbook = {
    imports = with config.flake.modules.homeManager; [
      packages
    ];
  };

  flake.modules.darwin.macbook = {
    imports = with config.flake.modules.darwin; [
      configuration
    ];
  };
}
