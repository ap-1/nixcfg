{ config, ... }:
{
  flake.modules.homeManager.common = {
    imports = [
      config.flake.modules.homeManager.git
      config.flake.modules.homeManager.ssh
      config.flake.modules.homeManager.gpg
      config.flake.modules.homeManager.shell
      config.flake.modules.homeManager.neovim
      config.flake.modules.homeManager.zed-editor
      config.flake.modules.homeManager.stylix
      config.flake.modules.homeManager.catppuccin
      config.flake.modules.homeManager.firefox
      config.flake.modules.homeManager.spicetify
      config.flake.modules.homeManager.discord
      config.flake.modules.homeManager.packages
    ];
  };

  flake.modules.nixos.common = {
    imports = [
      config.flake.modules.nixos.tailscale
      config.flake.modules.nixos.localsend
      config.flake.modules.nixos.nix-settings
      config.flake.modules.nixos.packages
    ];
  };

  flake.modules.darwin.common = {
    imports = [
      config.flake.modules.darwin.tailscale
      config.flake.modules.darwin.localsend
      config.flake.modules.darwin.nix-settings
      config.flake.modules.darwin.packages
    ];
  };
}
