{ lib, pkgs, ... }:

{
  imports = [
    ../../modules/home/git.nix
    ../../modules/home/gpg.nix
    ../../modules/home/neovim.nix
    ../../modules/home/shell.nix
    ../../modules/home/ssh.nix
    ../../modules/home/nixpkgs.nix
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
    git-filter-repo
    marp-cli
    dioxus-cli
    wasm-bindgen-cli
    ragenix
    bun
    uv
    openbao

    # applications
    shottr
    raycast
  ];

  programs.zsh.shellAliases.update = "nh darwin switch";

  programs.ssh = {
    matchBlocks."*".extraOptions = {
      IgnoreUnknown = "UseKeychain";
      UseKeychain = "yes";
    };
  };
}
