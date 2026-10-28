{ config, inputs, ... }:
let
  hosts = config.flake.hosts;
in
{
  flake.modules.nixos.iets =
    { config, pkgs, ... }:
    {
      imports = [ inputs.iets.nixosModules.default ];

      iets.classic = {
        enable = true;
        nix = pkgs.lixPackageSets.stable.lix;
      };

      environment.variables.IETS_WORKERS = toString hosts.${config.networking.hostName}.ietsWorkers;
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

      environment.variables.IETS_WORKERS = toString hosts.${config.networking.hostName}.ietsWorkers;
    };
}
