{ config, inputs, ... }:
let
  hosts = config.flake.hosts;
in
{
  flake.modules.nixos.iets =
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
      imports = [ inputs.iets.nixosModules.default ];

      iets.classic = {
        enable = true;
        nix = pkgs.lixPackageSets.lix_2_96.lix;
      };

      environment.systemPackages = [ (lib.hiPrio iets) ];
      nix.package = lib.mkForce (inputs.iets.lib.mkClassic pkgs iets config.iets.classic.nix);

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
