{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    pfetch
    discord-canary
    slack
    moonlight-qt
    prismlauncher
    qbittorrent
    tmux
    claude-code
    devenv
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
