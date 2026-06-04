{
  flake.modules.darwin.configuration =
    { self, ... }:
    {
      # Enable the Determinate Nix module
      determinateNix.enable = true;

      # Networking options
      networking.hostName = "ap-1";
      networking.localHostName = "ap-1";
      networking.computerName = "ap-1";

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
        casks = [ "zed" ];
      };

      # VPN
      programs.cloudflare-warp.enable = true;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      # Workarounds for upstream nixpkgs bugs on the pinned nixos-26.05 rev.
      # Drop each once its referenced PR/fix lands.
      nixpkgs.overlays = [
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
        # `llvmPackages_18.compiler-rt-libc` fails on Darwin because the Apple
        # SDK bump to libcxx 21 dropped clang-18 fallbacks for
        # `__builtin_ctzg`/`__builtin_clzg`, so the C++ components of
        # compiler-rt 18 no longer compile. Mirror the fix from PR #523142.
        # https://github.com/NixOS/nixpkgs/pull/523142
        (_: prev: {
          llvmPackages_18 = prev.llvmPackages_18.overrideScope (
            _: lsuper: {
              compiler-rt-libc = lsuper.compiler-rt-libc.overrideAttrs (old: {
                cmakeFlags = (old.cmakeFlags or [ ]) ++ [
                  "-DCOMPILER_RT_BUILD_XRAY:BOOL=OFF"
                  "-DCOMPILER_RT_BUILD_LIBFUZZER:BOOL=OFF"
                  "-DCOMPILER_RT_BUILD_MEMPROF:BOOL=OFF"
                  "-DCOMPILER_RT_BUILD_ORC:BOOL=OFF"
                ];
              });
            }
          );
        })
      ];
    };
}
