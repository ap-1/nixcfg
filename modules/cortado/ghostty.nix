{ inputs, ... }: {
  flake.modules.homeManager.ghostty = { pkgs, ... }: {
    programs.ghostty = {
      enable = true;
      package = inputs.nixpkgs-ghostty.legacyPackages.${pkgs.stdenv.hostPlatform.system}.ghostty-bin;
      settings = {
        window-decoration = true;
        background-blur-radius = 20;
        background-opacity = 0.8;
      };
    };
  };
}
