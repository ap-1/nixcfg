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
    };
}
