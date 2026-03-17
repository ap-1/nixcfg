{
  flake.modules.homeManager.hyprland =
    { ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = builtins.readFile ./hyprland.conf;
      };
    };
}
