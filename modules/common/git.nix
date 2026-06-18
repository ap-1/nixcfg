{ config, ... }:
let
  meta = config.flake.meta;
in
{
  flake.modules.homeManager.git =
    { pkgs, ... }:
    {
      programs.git = {
        enable = true;
        signing = {
          format = "openpgp";
          key = "B1CA832135A8C503";
          signByDefault = true;
        };

        settings = {
          user = {
            name = meta.name;
            email = meta.email;
          };

          init.defaultBranch = "main";
          pull.rebase = true;
          tag.gpgSign = true;
          color.ui = "auto";
        };
      };

      programs.jujutsu = {
        enable = true;
        settings = {
          user = {
            name = meta.name;
            email = meta.email;
          };
          signing = {
            backend = "gpg";
            key = "B1CA832135A8C503";
            behavior = "own";
          };
          ui.default-command = "log";
          templates.commit_trailers = ''format_signed_off_by_trailer(self)'';
        };
      };

      programs.gh = {
        enable = true;
        gitCredentialHelper.enable = true;
        settings = {
          git_protocol = "ssh";
        };
      };

      home.packages = with pkgs; [ codeberg-cli ];
    };
}
