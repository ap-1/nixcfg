{ config, ... }:
let
  hosts = config.flake.hosts;

  devenvCaches = {
    substituters = [
      "https://devenv.cachix.org"
      "https://cachix.cachix.org"
    ];
    trusted-public-keys = [
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
    ];
  };
in
{
  flake.modules.nixos.nix-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      host = hosts.${config.networking.hostName};
    in
    {
      nix.package = pkgs.lixPackageSets.stable.lix;

      nix.settings = devenvCaches // {
        max-jobs = host.maxJobs;
        inherit (host) cores;

        # systemd-nspawn container tests in nixpkgs
        auto-allocate-uids = true;
        use-cgroups = true;
        extra-system-features = [ "uid-range" ];
        experimental-features = [
          "auto-allocate-uids"
          "cgroups"
        ];
      };

      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "discord-canary"
          "discord-canary-unwrapped"
          "slack"
          "firefox-bin"
          "firefox-bin-unwrapped"
          "enhancer-for-youtube"
          "pay-by-privacy"
          "apple_cursor"
          "spotify"
          "steam"
          "steam-unwrapped"
          "tetrio-desktop"
          "open-webui"
          "bluebubbles"
          "objectbox-linux" # bluebubbles
        ];
    };

  flake.modules.darwin.nix-settings =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      host = hosts.${config.networking.hostName};
    in
    {
      nix.package = pkgs.lixPackageSets.stable.lix;

      nix.settings = devenvCaches // {
        max-jobs = host.maxJobs;
        inherit (host) cores;
      };

      nixpkgs.config.allowUnfreePredicate =
        pkg:
        builtins.elem (lib.getName pkg) [
          "discord-canary"
          "slack"
          "tailscale-gui"
          "firefox-bin"
          "firefox-bin-unwrapped"
          "enhancer-for-youtube"
          "pay-by-privacy"
          "apple_cursor"
          "spotify"
          "shottr"
          "tetrio-desktop"
        ];
    };
}
