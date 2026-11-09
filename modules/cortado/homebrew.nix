{
  flake.modules.darwin.cortado-homebrew = {
    system.primaryUser = "anish";

    nix-homebrew = {
      enable = true;
      user = "anish";
    };

    homebrew = {
      enable = true;
      onActivation.cleanup = "zap";
      casks = [
        "bluebubbles"
        "citrix-workspace"
        "mouseless"
        "obs"
      ];
    };
  };
}
