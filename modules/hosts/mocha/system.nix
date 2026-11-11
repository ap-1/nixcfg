{
  config,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.mocha = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      config.flake.modules.nixos.mocha

      config.flake.modules.nixos.common
      config.flake.modules.nixos.desktop

      inputs.agenix.nixosModules.default
      inputs.srvos.nixosModules.desktop

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.backupFileExtension = "backup";
        home-manager.extraSpecialArgs = {
          inherit inputs;
          inherit (inputs)
            nix-flatpak
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
            config.flake.modules.homeManager.mocha

            inputs.nix-flatpak.homeManagerModules.nix-flatpak
          ];

          home.stateVersion = "25.05";
        };
      }
    ];
  };
}
