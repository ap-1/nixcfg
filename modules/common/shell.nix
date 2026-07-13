{ config, inputs, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.homeManager.shell =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    {
      imports = [ inputs.nix-index-database.homeModules.nix-index ];

      home.packages = [
        inputs.devenv.packages.${pkgs.stdenv.hostPlatform.system}.devenv
      ]
      ++ (with pkgs; [
        license-go
        pfetch
        tree
      ]);

      # enabled manually for catppuccin
      programs.bat.enable = true;
      programs.tmux.enable = true;

      programs.eza = {
        enable = true;
        git = true;
        icons = "auto";
      };

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
            export NIX_CONFIG="access-tokens = github.com=$(${lib.getExe pkgs.gh} auth token 2>/dev/null)"
          '')
          ''
            pfetch
          ''
        ];
      };

      programs.pay-respects = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.nix-index = {
        enable = true;
        # pay-respects owns command_not_found_handler
        enableZshIntegration = false;
      };
      programs.nix-index-database.comma.enable = true;

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
        settings.sync_address = "http://affogato.${meta.tailnetDomain}:8888";
      };
    };
}
