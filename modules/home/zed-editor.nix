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
      "terraform"
      "swift"
      "svelte"
      "toml"
      "biome"
      "nginx"
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
