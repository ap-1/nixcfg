{ config, inputs, ... }:
{
  flake.darwinConfigurations.cortado = inputs.nix-darwin.lib.darwinSystem {
    specialArgs = {
      inherit inputs;
      self = inputs.self;
    };
    modules = [
      config.flake.modules.darwin.common
      config.flake.modules.darwin.desktop
      config.flake.modules.darwin.cortado

      inputs.determinate.darwinModules.default
      inputs.agenix.nixosModules.default
      inputs.home-manager.darwinModules.home-manager
      {
        home-manager.backupFileExtension = "backup";
        home-manager.extraSpecialArgs = {
          inherit inputs;
          inherit (inputs)
            firefox-addons
            spicetify-nix
            ;
        };

        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.anish = {
          imports = [
            config.flake.modules.homeManager.common
            config.flake.modules.homeManager.desktop
            config.flake.modules.homeManager.cortado
          ];

          home.username = "anish";
          home.homeDirectory = inputs.nixpkgs.lib.mkForce "/Users/anish";
          home.stateVersion = "25.11";
        };
      }
    ];
  };
}
