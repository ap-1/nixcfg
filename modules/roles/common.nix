{ config, ... }:
{
  flake.modules.homeManager.common = {
    imports = with config.flake.modules.homeManager; [
      git
      ssh
      gpg
      shell
      neovim
      zed-editor
      stylix
      catppuccin
      firefox
      spicetify
      discord
      syncthing
      packages
    ];
  };

  flake.modules.nixos.common = {
    imports = with config.flake.modules.nixos; [
      tailscale
      tailscale-tls
      localsend
      nix-settings
      packages
    ];

    services.tailscale-tls = {
      hostname = "pc";
      tailnet = "meteor-banjo.ts.net";
    };
  };

  flake.modules.darwin.common = {
    imports = with config.flake.modules.darwin; [
      tailscale
      localsend
      nix-settings
      packages
    ];
  };
}
