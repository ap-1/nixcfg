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

  # crypto-rust backend and a bumped lock pull sequoia-openpgp 2.4, so gpg-sq handles pqc keys
  chameleonPqcOverlay = _: prev: {
    sequoia-chameleon-gnupg = prev.sequoia-chameleon-gnupg.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.capnproto ];
      cargoDeps = prev.rustPlatform.importCargoLock {
        lockFile = ./Cargo.lock;
      };
      postPatch = (old.postPatch or "") + ''
        cp ${./Cargo.lock} Cargo.lock
      '';
      cargoBuildNoDefaultFeatures = true;
      cargoBuildFeatures = [
        "sequoia-openpgp/crypto-rust"
        "sequoia-openpgp/allow-experimental-crypto"
        "sequoia-openpgp/allow-variable-time-crypto"
      ];
    });
  };
in
{
  flake.modules.nixos.gpg.nixpkgs.overlays = [ sqPqcOverlay chameleonPqcOverlay ];
  flake.modules.darwin.gpg.nixpkgs.overlays = [ sqPqcOverlay chameleonPqcOverlay ];

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
