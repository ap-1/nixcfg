{ lib, pkgs, ... }:

{
  imports = [
    ../../../modules-old/home
    ./syncthing.nix
  ];

  home.username = "anish";
  home.homeDirectory = lib.mkForce "/Users/anish";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    docker
    docker-compose
    colima
    sshpass
    typst
    ragenix
    bun
    uv
    openbao

    # applications
    shottr
    raycast
    ghostty-bin
    iina
  ];
}
