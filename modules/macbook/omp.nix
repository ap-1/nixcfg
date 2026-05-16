{ inputs, ... }:
{
  flake.modules.homeManager.omp =
    { pkgs, ... }:
    let
      # Upstream omp-nix's package.nix fetches pi_natives.*.node files that
      # can1357/oh-my-pi stopped publishing after v14.5.12 (natives are now
      # bundled into the single omp-* binary). Override the package locally
      # until omp-nix updates. https://git.molez.org/mandlm/omp-nix
      version = "15.1.2";
      platform =
        {
          "aarch64-darwin" = {
            binary = "omp-darwin-arm64";
            hash = "sha256-tBh3rJtZ7w37Zi0U0ZqtTBN5myhsvlzKYcRspzpqIEQ=";
          };
        }
        .${pkgs.stdenv.hostPlatform.system};

      omp = pkgs.stdenv.mkDerivation {
        pname = "oh-my-pi";
        inherit version;
        src = pkgs.fetchurl {
          url = "https://github.com/can1357/oh-my-pi/releases/download/v${version}/${platform.binary}";
          inherit (platform) hash;
        };
        dontUnpack = true;
        dontStrip = true;
        installPhase = "install -Dm755 $src $out/bin/omp";
        meta.mainProgram = "omp";
        meta.sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
      };
    in
    {
      imports = [ inputs.omp-nix.homeManagerModules.omp ];

      oh-my-pi = {
        enable = true;
        package = omp;
      };
    };
}
