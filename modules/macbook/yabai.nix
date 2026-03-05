{
  flake.modules.darwin.yabai =
    { pkgs, ... }:
    {
      security.accessibilityPrograms = [
        "${pkgs.skhd}/bin/skhd"
        "${pkgs.yabai}/bin/yabai"
      ];

      services.yabai = {
        enable = true;
        enableScriptingAddition = true;
        config = {
          layout = "bsp";
          window_placement = "second_child";

          top_padding = 10;
          bottom_padding = 10;
          left_padding = 10;
          right_padding = 10;
          window_gap = 10;

          mouse_follows_focus = "off";
          focus_follows_mouse = "off";

          mouse_modifier = "alt";
          mouse_action1 = "move";
          mouse_action2 = "resize";
          mouse_drop_action = "swap";

          window_opacity = "off";
          split_ratio = 0.5;
          auto_balance = "off";
        };
      };

      services.skhd = {
        enable = true;
        skhdConfig = ''
          # close window
          alt - q : yabai -m window --close

          # focus window
          alt - h : yabai -m window --focus west
          alt - j : yabai -m window --focus south
          alt - k : yabai -m window --focus north
          alt - l : yabai -m window --focus east

          # swap window
          shift + alt - h : yabai -m window --swap west
          shift + alt - j : yabai -m window --swap south
          shift + alt - k : yabai -m window --swap north
          shift + alt - l : yabai -m window --swap east

          # move window
          shift + alt + ctrl - h : yabai -m window --warp west
          shift + alt + ctrl - j : yabai -m window --warp south
          shift + alt + ctrl - k : yabai -m window --warp north
          shift + alt + ctrl - l : yabai -m window --warp east

          # resize window
          ctrl + alt - h : yabai -m window --resize left:-50:0; yabai -m window --resize right:-50:0
          ctrl + alt - j : yabai -m window --resize bottom:0:50; yabai -m window --resize top:0:50
          ctrl + alt - k : yabai -m window --resize top:0:-50; yabai -m window --resize bottom:0:-50
          ctrl + alt - l : yabai -m window --resize right:50:0; yabai -m window --resize left:50:0

          # toggle float and center
          shift + alt - t : yabai -m window --toggle float --grid 4:4:1:1:2:2

          # fullscreen
          alt - f : yabai -m window --toggle zoom-fullscreen
          shift + alt - f : yabai -m window --toggle native-fullscreen

          # toggle split
          alt - e : yabai -m window --toggle split

          # balance tree
          shift + alt - 0 : yabai -m space --balance

          # rotate tree
          alt - r : yabai -m space --rotate 270
          shift + alt - r : yabai -m space --rotate 90

          # focus spaces
          alt - 1 : yabai -m space --focus 1
          alt - 2 : yabai -m space --focus 2
          alt - 3 : yabai -m space --focus 3
          alt - 4 : yabai -m space --focus 4
          alt - 5 : yabai -m space --focus 5
          alt - 6 : yabai -m space --focus 6
          alt - 7 : yabai -m space --focus 7
          alt - 8 : yabai -m space --focus 8
          alt - 9 : yabai -m space --focus 9

          # move window to space
          shift + alt - 1 : yabai -m window --space 1
          shift + alt - 2 : yabai -m window --space 2
          shift + alt - 3 : yabai -m window --space 3
          shift + alt - 4 : yabai -m window --space 4
          shift + alt - 5 : yabai -m window --space 5
          shift + alt - 6 : yabai -m window --space 6
          shift + alt - 7 : yabai -m window --space 7
          shift + alt - 8 : yabai -m window --space 8
          shift + alt - 9 : yabai -m window --space 9
        '';
      };
    };
}
