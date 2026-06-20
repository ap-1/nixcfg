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
      xdg.configFile."hypr/modules/capture.lua".source = ./modules/capture.lua;
      xdg.configFile."wl-kbptr/config".source = ./wl-kbptr.conf;

      # enabled manually for catppuccin
      programs.foot = {
        enable = true;
        settings.main.font = "monospace:size=12";
        settings.colors-dark.alpha = 0.8;
      };
      programs.rofi.enable = true;
      services.dunst.enable = true;
    };

  flake.modules.nixos.hyprland =
    { pkgs, ... }:
    {
      programs.ydotool.enable = true;
      programs.gpu-screen-recorder.enable = true; # setcap KMS wrapper for promptless capture

      environment.systemPackages = with pkgs; [
        playerctl
        grim # screenshot
        slurp # region selection
        (writeShellApplication {
          name = "capture";
          runtimeInputs = [
            grim
            slurp
            jq
            wl-clipboard
            libnotify
          ];
          text = builtins.readFile ./capture.sh;
        })
      ];
    };
}
