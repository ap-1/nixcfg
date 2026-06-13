{
  flake.modules.homeManager.shell =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      home.packages = with pkgs; [
        pfetch
        tree
      ];

      # enabled manually for stylix
      programs.bat.enable = true;
      programs.eza.enable = true;
      programs.tmux.enable = true;
      programs.vivid.enable = true;
      programs.zellij.enable = true;

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

            export NIX_CONFIG="access-tokens = github.com=$(${lib.getExe pkgs.gh} auth token 2>/dev/null)"
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

      # TODO: upstream an atuin target to nix-community/stylix and drop this.
      programs.atuin = {
        enable = true;
        enableZshIntegration = true;
        settings.theme.name = "catppuccin-mocha-mauve";
      };

      home.file.".config/atuin/themes/catppuccin-mocha-mauve.toml".source = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/atuin/68aa64b77573c235044b614e752a781701af4eec/themes/mocha/catppuccin-mocha-mauve.toml";
        hash = "sha256-X66L7YmWQ4ClPeQoFhXkkWXPrmpLwWfHcDNbvnc+K3g=";
      };
    };
}
