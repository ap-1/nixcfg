{
  flake.modules.darwin.cortado-configuration =
    {
      self,
      inputs,
      ...
    }:
    {
      # Networking options
      networking.hostName = "cortado";
      networking.localHostName = "cortado";
      networking.computerName = "cortado";

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 6;

      # Unlock sudo via fingerprint
      security.pam.services.sudo_local.touchIdAuth = true;

      # Homebrew
      system.primaryUser = "anish";

      homebrew = {
        enable = true;
        onActivation.cleanup = "none";
        casks = [ "bluebubbles" ];
      };

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Workarounds for upstream nixpkgs bugs.
      # Drop each once its referenced PR/fix lands.
      nixpkgs.overlays = [
        (_: _: {
          inherit
            (import inputs.nixpkgs-discord {
              system = "aarch64-darwin";
              config.allowUnfree = true;
            })
            discord
            discord-canary
            discord-ptb
            discord-development
            ;
        })
        # `darwin.PowerManagement` ships a stale `xcodeHash`, so
        # `system-applications` (caffeinate) fails its post-unpack hash check.
        # https://github.com/NixOS/nixpkgs/blob/nixos-26.05/pkgs/os-specific/darwin/by-name/po/PowerManagement/package.nix
        (_: prev: {
          darwin = prev.darwin.overrideScope (
            _: dsuper: {
              PowerManagement = dsuper.PowerManagement.overrideAttrs (_: {
                xcodeHash = "sha256-06rCxqBUrYqBY7BDZ6s/vSoviUAmIbsQP1pfrvR2Gpk=";
              });
            }
          );
        })
      ];
    };
}
