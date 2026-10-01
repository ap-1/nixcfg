{ config, lib, ... }:
let
  meta = config.flake.meta;
  hosts = config.flake.hosts;

  builders = {
    cortado = {
      sshUser = "anish";
      systems = [ "aarch64-darwin" ];
      protocol = "ssh-ng";
      maxJobs = 8;
      speedFactor = 2;
      supportedFeatures = [ "big-parallel" ];
    };

    mocha = {
      sshUser = "anish";
      systems = [ "x86_64-linux" ];
      protocol = "ssh-ng";
      maxJobs = 12;
      speedFactor = 2;
      supportedFeatures = [
        "big-parallel"
        "kvm"
        "nixos-test"
      ];
    };
  };

  tailnetName = name: "${name}.${meta.tailnetDomain}";

  # offload to every builder except the host itself
  mkOffload =
    adminGroup:
    { config, ... }:
    let
      others = lib.filterAttrs (name: _: name != config.networking.hostName) builders;
    in
    {
      nix.distributedBuilds = true;
      nix.settings.builders-use-substitutes = true;
      nix.settings.trusted-users = [
        "root"
        adminGroup
      ];
      nix.buildMachines = lib.mapAttrsToList (name: b: b // { hostName = tailnetName name; }) others;
      programs.ssh.knownHosts = lib.mapAttrs' (
        name: _: lib.nameValuePair (tailnetName name) { publicKey = hosts.${name}.sshKey; }
      ) others;
    };
in
{
  flake.modules.nixos.distributed-builds = mkOffload "@wheel";
  flake.modules.darwin.distributed-builds = mkOffload "@admin";
}
