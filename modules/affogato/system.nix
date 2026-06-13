{ config, inputs, ... }:
{
  flake.nixosConfigurations.affogato = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.modules.nixos.affogato

      config.flake.modules.nixos.common

      inputs.agenix.nixosModules.default
      inputs.disko.nixosModules.disko
      inputs.preservation.nixosModules.preservation

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.backupFileExtension = "backup";
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.anish = {
          imports = [
            config.flake.modules.homeManager.common
          ];

          home.stateVersion = "26.11";
        };
      }
    ];
  };
}
