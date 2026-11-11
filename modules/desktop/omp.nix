{ inputs, ... }:
{
  flake.modules.homeManager.omp =
    { lib, pkgs, ... }:
    {
      imports = [ inputs.oh-my-pi.homeManagerModules.default ];

      programs.omp = {
        enable = true;
        # TODO: https://github.com/NixOS/nixpkgs/pull/585738
        package = inputs.nixpkgs-omp.legacyPackages.${pkgs.stdenv.hostPlatform.system}.omp;
        settings = {
          setupVersion = 1;
          theme.dark = "dark-catppuccin";
          computer.enabled = true;
        };
      };

      # expose AX trees for computer use
      dconf.settings = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        "org/gnome/desktop/interface".toolkit-accessibility = true;
      };
    };

  flake.modules.nixos.omp = {
    services.gnome.at-spi2-core.enable = true; # accessibility bus for computer use AX
  };
}
