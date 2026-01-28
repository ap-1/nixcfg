{
  self,
  lib,
  pkgs,
  ...
}:

{
  imports = [ ../../modules/system ];

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
      "zed"
    ];
  };

  # VPN
  programs.tailscale-gui.enable = true; # must be in /Applications/Tailscale.app
  programs.cloudflare-warp.enable = true; # nix-darwin module enables launchd daemon

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";
}
