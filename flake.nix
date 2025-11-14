{
  description = "Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    catppuccin.url = "github:catppuccin/nix";

    xdg-termfilepickers.url = "github:Guekka/xdg-desktop-portal-termfilepickers/195ba6bb4a4f0224b0e749f2198fc88696be6383";

    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { nixpkgs, home-manager, catppuccin, xdg-termfilepickers, neovim-nightly-overlay, ... }: {
    nixosConfigurations.ap-1 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        ./hardware-configuration.nix # Include the results of the hardware scan

        home-manager.nixosModules.home-manager
        {
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = {
            inherit xdg-termfilepickers neovim-nightly-overlay;
          };

          home-manager.users.anish = {
            imports = [
              ./home.nix

              catppuccin.homeModules.catppuccin
              xdg-termfilepickers.homeManagerModules.default
            ];
          };
        }
      ];
    };
  };
}

