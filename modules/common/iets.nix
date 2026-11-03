{ config, inputs, ... }:
let
  hosts = config.flake.hosts;
  ietsFor =
    pkgs:
    inputs.iets.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [ ./iets-lix-fetchgit.patch ];
    });
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
      iets = ietsFor pkgs;
    in
    {
      imports = [ inputs.iets.nixosModules.default ];

      iets.classic = {
        enable = true;
        nix = pkgs.lixPackageSets.stable.lix;
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
      iets = ietsFor pkgs;
    in
    {
      environment.systemPackages = [
        iets
        (lib.hiPrio (inputs.iets.lib.mkClassic pkgs iets config.nix.package))
      ];

      environment.variables.IETS_WORKERS = toString hosts.${config.networking.hostName}.ietsWorkers;
    };
}
