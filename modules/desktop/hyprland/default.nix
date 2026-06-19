{
  flake.modules.homeManager.hyprland =
    { ... }:
    {
      wayland.windowManager.hyprland = {
        enable = true;
        configType = "lua";
        extraConfig = builtins.readFile ./hyprland.lua;
      };

      xdg.configFile."hypr/modules/wl-kbptr.lua".source = ./modules/wl-kbptr.lua;
      xdg.configFile."hypr/modules/media-keys.lua".source = ./modules/media-keys.lua;
      xdg.configFile."hypr/modules/monitors.lua".source = ./modules/monitors.lua;
      xdg.configFile."hypr/modules/autostart.lua".source = ./modules/autostart.lua;
      xdg.configFile."hypr/modules/window-rules.lua".source = ./modules/window-rules.lua;

      # enabled manually for catppuccin
      programs.foot = {
        enable = true;
        settings.main.font = "monospace:size=12";
        settings.colors-dark.alpha = 0.8;
      };
      programs.rofi.enable = true;
      services.dunst.enable = true;
    };

  flake.modules.nixos.hyprland = {
    programs.ydotool.enable = true;
  };
}
