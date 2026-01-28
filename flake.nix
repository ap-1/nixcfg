{
  description = "Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master"; # nixos-unstable

    nix-darwin = {
      # url = "github:nix-darwin/nix-darwin";
      url = "github:ap-1/nix-darwin/programs-gui-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";
    xdg-termfilepickers.url = "github:Guekka/xdg-desktop-portal-termfilepickers/195ba6bb4a4f0224b0e749f2198fc88696be6383";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      catppuccin,
      xdg-termfilepickers,
      neovim-nightly-overlay,
      nix-flatpak,
    }:
    {
      formatter = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (
        system: nixpkgs.legacyPackages.${system}.nixfmt
      );

      nixosConfigurations.ap-1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/pc/configuration.nix
          ./hosts/pc/hardware-configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              inherit
                inputs
                xdg-termfilepickers
                neovim-nightly-overlay
                nix-flatpak
                ;
            };

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.anish = {
              imports = [
                ./hosts/pc/home.nix

                catppuccin.homeModules.catppuccin
                xdg-termfilepickers.homeManagerModules.default
                nix-flatpak.homeManagerModules.nix-flatpak
              ];
            };
          }
        ];
      };

      darwinConfigurations."MacBook-Pro-19" = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit self; };
        modules = [
          ./hosts/macbook/configuration.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.backupFileExtension = "backup";
            home-manager.extraSpecialArgs = {
              inherit inputs neovim-nightly-overlay;
            };

            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.users.anish = {
              imports = [
                ./hosts/macbook/home.nix

                catppuccin.homeModules.catppuccin
              ];
            };
          }
        ];
      };
    };
}
