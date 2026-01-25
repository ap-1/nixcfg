{ self, lib, pkgs, ... }:

{
  imports = [ ../../modules/system/settings.nix ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    nh
  ];

  environment.variables.NH_DARWIN_FLAKE = "/etc/nix-darwin";

  # Add self as a trusted user
  nix.settings.trusted-users = [ "anish" ];

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

    casks = [
      "ghostty"
      "steam"
    ];
  };

  # Unfree packages
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "shottr"
    "raycast"
  ];

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
