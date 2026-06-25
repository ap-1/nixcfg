# Desktop

mocha runs [Hyprland](https://hyprland.org/) configured in Lua, with modules split into separate files. Submaps group modal keybinds; `Escape` exits any submap.

## Mouseless

[wl-kbptr](https://github.com/moverest/wl-kbptr) and [wlrctl](https://sr.ht/~brocellous/wlrctl/) provide keyboard-driven pointer control through the `SUPER+G` cursor submap:

- `SUPER+;` uses OpenCV (via wl-kbptr's `source=detect`) to capture the screen, detect clickable elements, and label them for type-to-click.
- `SUPER+SHIFT+;` opens a grid-then-split mode where you type a grid label to select a tile, then use arrow keys to narrow within it (`S/D/F` for left/middle/right click, `Enter`/`Space` to place the cursor).
- Inside the cursor submap, `H/J/K/L` nudge the pointer, `S/D/F` click left/middle/right, `E/R` scroll, and `A` jumps to a detected element. Any mouse click also exits.
- [ydotool](https://github.com/ReimuNotMoe/ydotool) handles scroll wheel emulation since wlrctl is [broken in Firefox](https://github.com/hyprwm/Hyprland/issues/8931).

## File chooser

File dialogs are routed through [xdg-desktop-portal-termfilepickers](https://github.com/Guekka/xdg-desktop-portal-termfilepickers), which opens [yazi](https://yazi-rs.github.io/) in a foot terminal instead of the GTK file picker.

## Capture

`SUPER+R` opens the capture submap:

- `S/D/F` screenshot the screen, a region (via [slurp](https://github.com/emersion/slurp)), or the focused window (via [grim](https://sr.ht/~emersion/grim/)). Screenshots are copied to the clipboard.
- `SHIFT+S/D/F` toggle recording of the same targets using [gpu-screen-recorder](https://git.dec05eba.com/gpu-screen-recorder/about/).
- `R` saves the last 30 seconds from a persistent replay buffer.
- `Print` opens a rofi menu listing all actions.
- Waybar shows a recording indicator when active.
