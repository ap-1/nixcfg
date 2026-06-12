{
  flake.modules.homeManager.hyprland =
    { ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = builtins.readFile ./hyprland.conf;
      };

      # enabled manually for catppuccin
      programs.rofi.enable = true;
      services.dunst.enable = true;
    };
}
