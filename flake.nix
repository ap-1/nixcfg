{
  description = "Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/3";
    nix-darwin = {
      # url = "github:nix-darwin/nix-darwin";
      url = "github:ap-1/nix-darwin/programs-gui-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    agenix.url = "github:ryantm/agenix";
    catppuccin.url = "github:catppuccin/nix";
    xdg-termfilepickers.url = "github:Guekka/xdg-desktop-portal-termfilepickers/195ba6bb4a4f0224b0e749f2198fc88696be6383";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      determinate,
      nix-darwin,
      home-manager,
      nix-flatpak,
      nix-cachyos-kernel,
      agenix,
      catppuccin,
      xdg-termfilepickers,
      neovim-nightly-overlay,
    }:
    {
      formatter = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ] (
        system: nixpkgs.legacyPackages.${system}.nixfmt
      );

      nixosConfigurations.ap-1 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          isLinux = true;
        };
        modules = [
          determinate.nixosModules.default
          agenix.nixosModules.default

          ./hosts/pc/configuration

          # CachyOS kernel overlay
          (
            { pkgs, ... }:
            {
              nixpkgs.overlays = [ nix-cachyos-kernel.overlays.pinned ];
              boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v4;

              nix.settings = {
                substituters = [
                  "https://attic.xuyh0120.win/lantian"
                  "https://cache.garnix.io"
                ];
                trusted-public-keys = [
                  "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
                  "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
                ];
              };
            }
          )

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
                ./hosts/pc/home

                catppuccin.homeModules.catppuccin
                xdg-termfilepickers.homeManagerModules.default
                nix-flatpak.homeManagerModules.nix-flatpak
              ];
            };
          }
        ];
      };

      darwinConfigurations.ap-1 = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit self;
          isLinux = false;
        };
        modules = [
          determinate.darwinModules.default
          agenix.nixosModules.default

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
                ./hosts/macbook/home

                catppuccin.homeModules.catppuccin
              ];
            };
          }
        ];
      };
    };
}
