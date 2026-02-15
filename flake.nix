{
  description = "Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

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

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    xdg-termfilepickers = {
      url = "github:Guekka/xdg-desktop-portal-termfilepickers/9a4a40fee7a6973f581404b6fa1f1107026d05f8";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { config, ... }:
      {
        imports = [
          inputs.flake-parts.flakeModules.modules
          (inputs.import-tree ./modules)
        ];

        systems = [
          "x86_64-linux"
          "aarch64-darwin"
        ];

        perSystem =
          { pkgs, ... }:
          {
            formatter = pkgs.nixfmt;
          };

        flake = {
          nixosConfigurations.ap-1 = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              ./hosts/pc/configuration

              config.flake.modules.nixos.common

              inputs.determinate.nixosModules.default
              inputs.agenix.nixosModules.default

              # CachyOS kernel overlay
              (
                { pkgs, ... }:
                {
                  nixpkgs.overlays = [ inputs.nix-cachyos-kernel.overlays.pinned ];
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

              inputs.home-manager.nixosModules.home-manager
              {
                home-manager.backupFileExtension = "backup";
                home-manager.extraSpecialArgs = {
                  inherit inputs;
                  inherit (inputs)
                    nix-flatpak
                    xdg-termfilepickers
                    firefox-addons
                    spicetify-nix
                    ;
                };

                home-manager.useGlobalPkgs = true;
                home-manager.useUserPackages = true;

                home-manager.users.anish = {
                  imports = [
                    ./hosts/pc/home

                    config.flake.modules.homeManager.common

                    inputs.stylix.homeModules.stylix
                    inputs.catppuccin.homeModules.catppuccin
                    inputs.xdg-termfilepickers.homeManagerModules.default
                    inputs.nix-flatpak.homeManagerModules.nix-flatpak
                    inputs.spicetify-nix.homeManagerModules.spicetify
                  ];
                };
              }
            ];
          };

          darwinConfigurations.ap-1 = inputs.nix-darwin.lib.darwinSystem {
            specialArgs = {
              self = inputs.self;
            };
            modules = [
              ./hosts/macbook/configuration.nix

              config.flake.modules.darwin.common

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
                    ./hosts/macbook/home

                    config.flake.modules.homeManager.common

                    inputs.stylix.homeModules.stylix
                    inputs.catppuccin.homeModules.catppuccin
                    inputs.spicetify-nix.homeManagerModules.spicetify
                  ];
                };
              }
            ];
          };
        };
      }
    );
}
