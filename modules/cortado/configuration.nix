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
        # TODO: https://github.com/NixOS/nixpkgs/pull/541649
        (_: prev: {
          darwin = prev.darwin.overrideScope (
            _: dsuper: {
              PowerManagement = dsuper.PowerManagement.overrideAttrs (_: {
                xcodeHash = "sha256-8dASJnzc7yZ4LNbanNjWuCoJunxAz/7R1Ulj/zOrkkI=";
              });
            }
          );
        })
        # ld64's libc++ hardening asserts (Trace/BPT trap: 5) on real links under macOS 26+; route
        # affected packages through lld until NixOS/nixpkgs#536365 disables that hardening upstream.
        (final: prev:
          let
            useLld =
              pkg:
              pkg.overrideAttrs (old: {
                nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ final.lld ];
                env = (old.env or { }) // {
                  NIX_CFLAGS_LINK = ((old.env or { }).NIX_CFLAGS_LINK or "") + " -fuse-ld=lld";
                };
              });
          in
          {
            moonlight-qt = useLld prev.moonlight-qt;
            lima = useLld prev.lima;
            colima = useLld prev.colima;
            sunshine = useLld prev.sunshine;
            proxmark3 = useLld prev.proxmark3;
            bitwarden-desktop = useLld prev.bitwarden-desktop;
            zed-editor = useLld prev.zed-editor;
          }
        )
      ];
    };
}
