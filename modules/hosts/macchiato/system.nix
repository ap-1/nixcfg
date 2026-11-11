{
  config,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.macchiato = inputs.nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      config.flake.modules.nixos.macchiato

      config.flake.modules.nixos.common
      config.flake.modules.nixos.desktop

      inputs.nixos-apple-silicon.nixosModules.apple-silicon-support
      inputs.agenix.nixosModules.default
      inputs.srvos.nixosModules.desktop

      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.backupFileExtension = "backup";
        home-manager.extraSpecialArgs = {
          inherit inputs;
          inherit (inputs) firefox-addons;
        };

        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.anish = {
          imports = [
            config.flake.modules.homeManager.common
            config.flake.modules.homeManager.desktop
            config.flake.modules.homeManager.macchiato
          ];

          home.stateVersion = "26.05";
        };
      }
    ];
  };
}
