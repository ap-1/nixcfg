{
  flake.modules.homeManager.neovim = {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      withRuby = false;
      withPython3 = false;
    };
  };
}
