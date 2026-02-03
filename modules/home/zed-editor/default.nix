{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    userSettings = {
      vim_mode = true;
      load_direnv = "shell_hook";
      base_keymap = "VSCode";
    };
  };
}
