{ ... }:

{
  imports = [
    ./git.nix
    ./gpg.nix
    ./neovim.nix
    ./shell.nix
    ./ssh.nix
    ./packages.nix
    ./catppuccin.nix
    ./zed-editor
  ];
}
