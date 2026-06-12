{ config, ... }:
{
  flake.modules.homeManager.cortado = {
    imports = with config.flake.modules.homeManager; [
      cortado-packages
    ];
  };

  flake.modules.darwin.cortado = {
    imports = with config.flake.modules.darwin; [
      configuration
    ];
  };
}
