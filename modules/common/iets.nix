{ inputs, ... }:
{
  flake.modules.nixos.iets = {
    imports = [ inputs.iets.nixosModules.default ];

    iets.classic.enable = true;
  };

  flake.modules.darwin.iets =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      iets = inputs.iets.packages.${pkgs.stdenv.hostPlatform.system}.default;
    in
    {
      environment.systemPackages = [
        iets
        (lib.hiPrio (inputs.iets.lib.mkClassic pkgs iets config.nix.package))
      ];
    };
}
