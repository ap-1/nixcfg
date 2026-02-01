{ lib, pkgs, ... }:

{
  imports = [
    ../../../modules/home
    ./syncthing.nix
  ];

  home.username = "anish";
  home.homeDirectory = lib.mkForce "/Users/anish";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    docker
    docker-compose
    colima
    nixd # nix language server
    nil # also a nix language server
    sshpass
    rustup
    typst
    ragenix
    bun
    uv
    openbao

    # applications
    shottr
    raycast
    ghostty-bin
  ];

  programs.zsh.shellAliases.update = "nh darwin switch ~/dotfiles";

  programs.ssh = {
    matchBlocks."*".extraOptions = {
      IgnoreUnknown = "UseKeychain";
      UseKeychain = "yes";
    };
  };
}
