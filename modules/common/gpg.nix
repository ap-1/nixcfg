let
  sqPqcOverlay = _: prev: {
    sequoia-sq = prev.sequoia-sq.overrideAttrs (old: {
      version = "1.4.0-pqc.1";
      src = prev.fetchFromGitLab {
        owner = "sequoia-pgp";
        repo = "sequoia-sq";
        tag = "v1.4.0-pqc.1";
        hash = "sha256-ep3il5In0ecyNWHvCo0yh4yL92VTy3/FligzKkY+SJQ=";
      };
      cargoDeps = prev.rustPlatform.fetchCargoVendor {
        name = "sequoia-sq-1.4.0-pqc.1-vendor";
        src = prev.fetchFromGitLab {
          owner = "sequoia-pgp";
          repo = "sequoia-sq";
          tag = "v1.4.0-pqc.1";
          hash = "sha256-ep3il5In0ecyNWHvCo0yh4yL92VTy3/FligzKkY+SJQ=";
        };
        hash = "sha256-NYUYQCKG4XWchvuEzzAD+R25Wk0YrHN4ISVtQnhPkcM=";
      };
      cargoBuildNoDefaultFeatures = true;
      cargoBuildFeatures = [ "crypto-openssl" ];
      cargoCheckNoDefaultFeatures = true;
      cargoCheckFeatures = [ "crypto-openssl" ];
    });
  };
in
{
  flake.modules.nixos.gpg.nixpkgs.overlays = [ sqPqcOverlay ];
  flake.modules.darwin.gpg.nixpkgs.overlays = [ sqPqcOverlay ];

  flake.modules.homeManager.gpg =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        sequoia-sq
        sequoia-chameleon-gnupg
      ];

      services.gpg-agent = {
        enable = true;
        enableZshIntegration = true;
        defaultCacheTtl = 86400;
        maxCacheTtl = 86400;
        pinentry.package = if pkgs.stdenv.isDarwin then pkgs.pinentry_mac else pkgs.pinentry-curses;
      };
    };
}
