{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    pfetch
    tmux
    tree
    devenv
    claude-code

    # applications
    discord-canary
    slack
    prismlauncher
    moonlight-qt
    qbittorrent
  ];

  programs.zsh = {
    enable = true;
    enableCompletion = true;

    shellAliases = {
      cat = "bat --style=plain --paging=never";
    };

    initContent = lib.mkMerge [
      (lib.mkBefore ''
        zstyle ':omz:plugins:eza' 'git-status' yes
        zstyle ':omz:plugins:eza' 'icons' yes
      '')
      ''
        pfetch
      ''
    ];

    oh-my-zsh = {
      enable = true;
      plugins = [ "eza" ];
    };
  };

  programs.bat.enable = true;
  programs.eza.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings.direnv.disabled = false;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };

  programs.atuin = {
    enable = true;
    enableZshIntegration = true;
  };
}
