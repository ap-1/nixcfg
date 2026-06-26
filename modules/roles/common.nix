{
  config,
  inputs,
  ...
}:
{
  flake.modules.homeManager.common = {
    imports = with config.flake.modules.homeManager; [
      git
      ssh
      gpg
      shell
      neovim
      catppuccin
      stylix
    ];
  };

  flake.modules.nixos.common = { pkgs, ... }: {
    imports =
      (with config.flake.modules.nixos; [
        tailscale
        web-proxy
        nix-settings
        memory
      ])
      ++ [
        inputs.srvos.nixosModules.mixins-terminfo
        inputs.srvos.nixosModules.mixins-trusted-nix-caches
      ];

    environment.systemPackages = with pkgs; [
      (runCommand "age-plugin-pq" { } ''
        mkdir -p $out/bin
        ln -s ${age}/bin/age-plugin-pq $out/bin/age-plugin-pq
      '')
      nh
      rage
      ragenix
      jq
    ];
  };

  flake.modules.darwin.common = { pkgs, ... }: {
    imports =
      (with config.flake.modules.darwin; [
        tailscale
        nix-settings
      ])
      ++ [
        inputs.srvos.darwinModules.mixins-terminfo
        inputs.srvos.darwinModules.mixins-trusted-nix-caches
      ];

    environment.systemPackages = with pkgs; [
      (runCommand "age-plugin-pq" { } ''
        mkdir -p $out/bin
        ln -s ${age}/bin/age-plugin-pq $out/bin/age-plugin-pq
      '')
      nh
      rage
      ragenix
      jq
    ];
  };
}
