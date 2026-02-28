{
  flake.modules.homeManager.shell =
    {
      lib,
      pkgs,
      config,
      inputs,
      ...
    }:
    {
      home.packages = with pkgs; [
        pfetch
        tree
        devenv
      ];

      # enabled manually for catppuccin
      programs.bat.enable = true;
      programs.eza.enable = true;
      programs.tmux.enable = true;

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        dotDir = "${config.xdg.configHome}/zsh";

        shellAliases = {
          cat = "bat --style=plain --paging=never";
          update = if pkgs.stdenv.isDarwin then "nh darwin switch ~/nixcfg" else "nh os switch ~/nixcfg";
        };

        initContent = lib.mkMerge [
          (lib.mkBefore ''
            zstyle ':omz:plugins:eza' 'git-status' yes
            zstyle ':omz:plugins:eza' 'icons' no
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

      programs.direnv = {
        enable = true;
        silent = true;
        nix-direnv.enable = true;
        enableZshIntegration = true;
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
    };
}
