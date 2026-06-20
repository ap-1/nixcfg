{
  flake.modules.homeManager.waybar =
    { ... }:
    {
      programs.waybar = {
        enable = true;
        systemd.enable = true;
        style = builtins.readFile ./style.css;
        settings.mainBar = {
          layer = "top";
          position = "top";
          spacing = 0;

          modules-left = [
            "hyprland/workspaces"
            "hyprland/submap"
          ];
          modules-center = [ "hyprland/window" ];
          modules-right = [
            "wireplumber"
            "network"
            "clock"
            "tray"
          ];

          "hyprland/workspaces" = {
            format = "{name}";
            on-scroll-up = "hyprctl dispatch workspace e-1";
            on-scroll-down = "hyprctl dispatch workspace e+1";
          };

          "hyprland/submap" = {
            format = "{}";
            tooltip = false;
          };

          "hyprland/window" = {
            max-length = 80;
          };

          clock = {
            format = "{:%a %d %b %H:%M}";
            tooltip-format = "{:%Y-%m-%d %H:%M:%S}";
          };

          wireplumber = {
            format = "vol {volume}%";
            format-muted = "vol muted";
            on-click = "foot -e wiremix";
          };

          network = {
            format-wifi = "wifi {signalStrength}%";
            format-ethernet = "eth";
            format-disconnected = "offline";
            tooltip-format-wifi = "{essid} ({signalStrength}%)";
            on-click = "foot -e impala";
          };

          tray = {
            spacing = 8;
          };
        };
      };
    };
}
