{ config, ... }:
{
  flake.modules.homeManager.macbook = {
    imports = with config.flake.modules.homeManager; [
      mac-packages
      omp
    ];
  };

  flake.modules.darwin.macbook = {
    imports = with config.flake.modules.darwin; [
      configuration
    ];
  };
}
