{
  self,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ../../../modules/system
    ./vpn.nix
  ];

  # Enable the Determinate Nix module
  determinateNix.enable = true;

  # Networking options
  networking.hostName = "ap-1";
  networking.localHostName = "ap-1";
  networking.computerName = "ap-1";

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
    casks = [ "zed" ];
  };

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
