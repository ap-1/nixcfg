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
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    preservation.url = "github:nix-community/preservation";
    gwfox = {
      url = "github:akkva/gwfox/42fb1a2310e64126054f8f95f7b27cc3ce1ccd87";
      flake = false;
    };
    xdg-termfilepickers = {
      url = "github:Guekka/xdg-desktop-portal-termfilepickers/9a4a40fee7a6973f581404b6fa1f1107026d05f8";
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
    moonlight = {
      url = "github:moonlight-mod/moonlight";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    omp-nix = {
      url = "git+https://git.molez.org/mandlm/omp-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    mt7927 = {
      url = "github:cmspam/mt7927-nixos";
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
          nixosConfigurations.mocha = inputs.nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
              config.flake.modules.nixos.mocha

              config.flake.modules.nixos.common
              config.flake.modules.nixos.desktop

              inputs.determinate.nixosModules.default
              inputs.agenix.nixosModules.default
              inputs.mt7927.nixosModules.default

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
                    config.flake.modules.homeManager.common
                    config.flake.modules.homeManager.desktop
                    config.flake.modules.homeManager.mocha

                    inputs.xdg-termfilepickers.homeManagerModules.default
                    inputs.nix-flatpak.homeManagerModules.nix-flatpak
                  ];

                  home.stateVersion = "25.05";
                };
              }
            ];
          };

          nixosConfigurations.affogato = inputs.nixpkgs.lib.nixosSystem {
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

          darwinConfigurations.cortado = inputs.nix-darwin.lib.darwinSystem {
            specialArgs = {
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
        };
      }
    );
}
