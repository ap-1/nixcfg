{ config, ... }:
{
  flake.modules.nixos.affogato = {
    imports = with config.flake.modules.nixos; [
      affogato-configuration
      affogato-hardware-configuration
      affogato-disko
      affogato-persist
    ];
  };
}
