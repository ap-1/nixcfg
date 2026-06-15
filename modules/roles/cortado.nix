{ config, ... }:
{
  flake.modules.homeManager.cortado = {
    imports = with config.flake.modules.homeManager; [
      cortado-packages
      ghostty
      syncthing
    ];
  };

  flake.modules.darwin.cortado = {
    imports = with config.flake.modules.darwin; [
      cortado-configuration
    ];
  };
}
