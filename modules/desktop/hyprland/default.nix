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
      programs.foot.enable = true;
      programs.rofi.enable = true;
      services.dunst.enable = true;
    };
}
