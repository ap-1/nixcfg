{ config, ... }:
{
  flake.modules.homeManager.common = {
    imports = with config.flake.modules.homeManager; [
      git
      ssh
      gpg
      shell
      neovim
    ];
  };

  flake.modules.nixos.common = {
    imports = with config.flake.modules.nixos; [
      tailscale
      tailscale-tls
      nix-settings
      packages
    ];
  };

  flake.modules.darwin.common = {
    imports = with config.flake.modules.darwin; [
      tailscale
      nix-settings
      packages
    ];
  };
}
