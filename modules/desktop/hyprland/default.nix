{
  flake.modules.homeManager.hyprland =
    { ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = builtins.readFile ./hyprland.conf;
      };

      # enabled manually for stylix
      programs.foot.enable = true;
      programs.rofi.enable = true;
      services.dunst.enable = true;
    };
}
