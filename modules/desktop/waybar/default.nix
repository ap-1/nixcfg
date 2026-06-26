{
  flake.modules.homeManager.waybar = { ... }: {
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
          "custom/recording"
          "mpris"
          "gamemode"
          "privacy"
          "wireplumber"
          "network"
          "clock"
          "tray"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          disable-scroll = false;
          on-scroll-up = "hyprctl dispatch 'hl.dsp.focus({workspace = \"-1\"})'";
          on-scroll-down = "hyprctl dispatch 'hl.dsp.focus({workspace = \"+1\"})'";
        };

        "hyprland/submap" = {
          format = "{}";
          tooltip = false;
        };

        "hyprland/window" = {
          max-length = 80;
        };

        clock = {
          format = "{:%a %d %b %I:%M:%S %p}";
          tooltip-format = "{:%Y-%m-%d %I:%M:%S %p}";
        };

        wireplumber = {
          format = "vol {volume}%";
          format-muted = "vol muted";
          on-click = "pkill wiremix || foot --app-id=wiremix -e wiremix";
        };

        network = {
          format-wifi = "wifi {signalStrength}%";
          format-ethernet = "eth";
          format-disconnected = "offline";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          on-click = "pkill impala || foot --app-id=impala -e impala";
        };

        tray = {
          spacing = 8;
        };

        mpris = {
          format = "{status_icon} {title}";
          format-paused = "{status_icon} {title}";
          format-stopped = "";
          status-icons = {
            playing = "▶";
            paused = "⏸";
          };
          max-length = 40;
        };

        gamemode = {
          format = "gamemode";
          format-alt = "gamemode {count}";
          hide-not-running = true;
        };

        privacy = {
          icon-size = 14;
          modules = [
            { type = "screenshare"; }
            { type = "audio-in"; }
            { type = "audio-out"; }
          ];
        };

        "custom/recording" = {
          exec = "capture status";
          return-type = "json";
          signal = 8;
        };
      };
    };
  };
}
