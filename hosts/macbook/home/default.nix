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

  programs.zsh.shellAliases.update = "nh darwin switch ~/nixcfg";

  programs.ssh = {
    matchBlocks."*".extraOptions = {
      IgnoreUnknown = "UseKeychain";
      UseKeychain = "yes";
    };
  };
}
