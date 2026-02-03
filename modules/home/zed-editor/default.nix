{ pkgs, ... }:

{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "ini"
      "rainbow-csv"
      "just"
      "typst"
    ];
    extraPackages = with pkgs; [
      nixd
      nil
    ];
    mutableUserKeymaps = false;
    mutableUserSettings = false;
    userSettings = {
      vim_mode = true;
      load_direnv = "shell_hook";
      base_keymap = "VSCode";
    };
  };
}
