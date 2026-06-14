{
  flake.modules.homeManager.hyprland =
    { ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        configType = "lua";
        extraConfig = builtins.readFile ./hyprland.lua;
      };

      # enabled manually for catppuccin
      programs.foot = {
        enable = true;
        settings.main.font = "monospace:size=12";
        settings.colors-dark.alpha = 0.8;
      };
      programs.rofi.enable = true;
      services.dunst.enable = true;
    };
}
