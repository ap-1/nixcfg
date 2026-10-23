{ config, lib, ... }:
let
  meta = config.flake.meta;
  hosts = config.flake.hosts;

  builders = {
    cortado = {
      sshUser = "anish";
      systems = [ "aarch64-darwin" ];
      protocol = "ssh-ng";
      speedFactor = 2;
      supportedFeatures = [ "big-parallel" ];
    };

    mocha = {
      sshUser = "anish";
      systems = [ "x86_64-linux" ];
      protocol = "ssh-ng";
      speedFactor = 2;
      supportedFeatures = [
        "big-parallel"
        "kvm"
        "nixos-test"
      ];
    };
  };

  tailnetName = name: "${name}.${meta.tailnetDomain}";

  nixbuild = "eu.nixbuild.net";
  nixbuildFeatures = [
    "benchmark"
    "big-parallel"
    "ca-derivations"
    "nixos-test"
    "uid-range"
  ];

  # offload to every builder except the host itself
  mkOffload =
    adminGroup:
    { config, ... }:
    let
      others = lib.filterAttrs (name: _: name != config.networking.hostName) builders;
    in
    {
      age.secrets.nixbuild-ssh-key.file = ../../secrets/nixbuild-ssh-key.age;

      nix = {
        distributedBuilds = true;
        settings = {
          builders-use-substitutes = true;
          trusted-users = [
            "root"
            adminGroup
          ];
        };
        buildMachines =
          lib.mapAttrsToList (
            name: b:
            b
            // {
              hostName = tailnetName name;
              inherit (hosts.${name}) maxJobs;
            }
          ) others
          ++ [
            {
              hostName = nixbuild;
              system = "x86_64-linux";
              protocol = "ssh-ng";
              maxJobs = 100;
              supportedFeatures = nixbuildFeatures ++ [ "kvm" ];
            }
            {
              hostName = nixbuild;
              system = "aarch64-linux";
              protocol = "ssh-ng";
              maxJobs = 100;
              supportedFeatures = nixbuildFeatures;
            }
          ];
      };

      programs.ssh = {
        knownHosts =
          lib.mapAttrs' (
            name: _: lib.nameValuePair (tailnetName name) { publicKey = hosts.${name}.sshKey; }
          ) others
          // {
            nixbuild = {
              hostNames = [ nixbuild ];
              publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
            };
          };
        extraConfig = ''
          Host ${nixbuild}
            ServerAliveInterval 60
            IdentityFile ${config.age.secrets.nixbuild-ssh-key.path}
        '';
      };
    };
in
{
  flake.modules.nixos.distributed-builds = mkOffload "@wheel";
  flake.modules.darwin.distributed-builds = mkOffload "@admin";
}
