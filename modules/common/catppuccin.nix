{ inputs, ... }: {
  flake.modules.homeManager.catppuccin = { ... }: {
    imports = [ inputs.catppuccin.homeModules.catppuccin ];

    catppuccin = {
      enable = true;
      autoEnable = false;
      flavor = "mocha";

      atuin.enable = true;
      bat.enable = true;
      dunst.enable = true;
      eza.enable = true;
      foot.enable = true;
      fzf.enable = true;
      ghostty.enable = true;
      hyprland.enable = true;
      mangohud.enable = true;
      rofi.enable = true;
      tmux.enable = true;
      yazi.enable = true;
      zed.enable = true;
      waybar.enable = true;
    };
  };
}
