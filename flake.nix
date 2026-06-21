{
  description = "Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-discord.url = "github:ap-1/nixpkgs/discord-canary-osx-0.0.1159";
    nixpkgs-cliproxyapi.url = "github:ap-1/nixpkgs/cliproxyapi";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin";
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
    catppuccin = {
      url = "github:catppuccin/nix";
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
    litellm-nix.url = "git+https://codeberg.org/anish/litellm-nix";
    srvos.url = "github:nix-community/srvos";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
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
    };
}
