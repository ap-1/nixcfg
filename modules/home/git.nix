{ ... }:

{
  programs.git = {
    enable = true;
    signing = {
      format = "openpgp";
      key = "841AFB689A5BACCB";
      signByDefault = true;
    };
    settings = {
      user = {
        name = "Anish Pallati";
        email = "i@anish.land";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
      tag.gpgSign = true;
      color.ui = "auto";
    };
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };
}
